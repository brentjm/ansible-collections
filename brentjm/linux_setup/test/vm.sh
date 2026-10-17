#!/usr/bin/env bash
# Throwaway Ubuntu 26.04 test VM under QEMU/KVM (no root needed).
# Usage: test/vm.sh up | ssh | down | destroy | status
# See docs/testing.md.
set -euo pipefail

cd "$(dirname "$0")"
STATE=.vm
IMG_NAME=ubuntu-26.04-server-cloudimg-amd64.img
IMG_URL=https://cloud-images.ubuntu.com/releases/resolute/release
BASE=$STATE/$IMG_NAME
DISK=$STATE/testbox.qcow2
SEED=$STATE/seed.iso
KEY=$STATE/id_ed25519
PID=$STATE/qemu.pid
PORT=2299
SSH=(ssh -i "$KEY" -p "$PORT" -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o LogLevel=ERROR tester@127.0.0.1)

running() { [[ -f $PID ]] && kill -0 "$(cat "$PID")" 2>/dev/null; }

download() {
  [[ -f $BASE ]] && return
  echo "Downloading $IMG_NAME"
  curl -fsSL -o "$BASE.part" "$IMG_URL/$IMG_NAME"
  curl -fsSL "$IMG_URL/SHA256SUMS" | grep " \*$IMG_NAME\$" | sed "s| \*.*|  $BASE.part|" | sha256sum -c -
  mv "$BASE.part" "$BASE"
}

create() {
  [[ -f $DISK ]] && return
  [[ -f $KEY ]] || ssh-keygen -q -t ed25519 -N "" -C testbox -f "$KEY"
  # Overlay on the downloaded image: destroy deletes only this file.
  qemu-img create -q -f qcow2 -b "$IMG_NAME" -F qcow2 "$DISK" 30G
  cat > $STATE/user-data <<EOT
#cloud-config
hostname: testbox
users:
  - name: tester
    sudo: ALL=(ALL) NOPASSWD:ALL
    shell: /bin/bash
    ssh_authorized_keys:
      - $(cat "$KEY.pub")
EOT
  printf 'instance-id: testbox\nlocal-hostname: testbox\n' > $STATE/meta-data
  genisoimage -quiet -output "$SEED" -volid cidata -joliet -rock $STATE/user-data $STATE/meta-data
}

case "${1:-}" in
  up)
    mkdir -p $STATE
    running && { echo "Already running"; exit 0; }
    download
    create
    qemu-system-x86_64 -enable-kvm -cpu host -smp 2 -m 4096 \
      -drive file="$DISK",if=virtio \
      -drive file="$SEED",if=virtio,format=raw,readonly=on \
      -nic user,model=virtio-net-pci,hostfwd=tcp:127.0.0.1:$PORT-:22 \
      -display none -daemonize -pidfile "$PID"
    printf 'Waiting for SSH'
    for _ in $(seq 60); do
      "${SSH[@]}" -o ConnectTimeout=3 true 2>/dev/null && { echo " ready"; exit 0; }
      printf '.'; sleep 5
    done
    echo " timed out"; exit 1 ;;
  ssh) "${SSH[@]}" "${@:2}" ;;
  down)
    running || { echo "Not running"; exit 0; }
    kill "$(cat "$PID")"; rm -f "$PID"; echo "Stopped" ;;
  destroy)
    "./$(basename "$0")" down
    rm -f "$DISK" "$SEED" $STATE/user-data $STATE/meta-data
    echo "Deleted the VM disk (downloaded image kept in $STATE)" ;;
  status) running && echo "Running (ssh port $PORT)" || echo "Stopped" ;;
  *) echo "Usage: $0 up | ssh [cmd] | down | destroy | status"; exit 1 ;;
esac

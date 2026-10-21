# Testing in a throwaway VM

`test/vm.sh` boots the Ubuntu 26.04 cloud image under QEMU/KVM (no root, no
VirtualBox). `test/inventory.ini` puts the VM in every group, so any playbook
can run against it instead of frigg or odin.

Needs on the host: `sudo apt install qemu-system-x86 qemu-utils genisoimage`
(`genisoimage` builds the cloud-init seed disk with the VM's user and SSH key).
The `test_vm` role installs these on odin (`workstation.yml --tags test_vm`).

```bash
cd brentjm/linux_setup
test/vm.sh up        # first run downloads the image (~600 MB) and checks its SHA256
ansible-playbook -i test/inventory.ini playbooks/trading_server.yml
ansible-playbook -i test/inventory.ini playbooks/trading_server.yml   # again: expect changed=0
test/vm.sh ssh       # look around (user tester, passwordless sudo)
test/vm.sh destroy   # delete the VM disk; the downloaded image is kept
```

- `vm.sh up | ssh | down | destroy | status`. State lives in `test/.vm/`
  (git-ignored): image, VM disk (a copy-on-write overlay), test SSH key.
- `username=tester` is a host variable in `test/inventory.ini`; it overrides
  `group_vars/all.yml` (linked into `test/`).
- The cloud image has no LVM, so the base role's "grow root LV" step is skipped
  here; it runs only on a real server install like frigg.
- Needs ansible-core 2.20+ (Python 3.14 in the VM), see
  [ansible_control_node.md](ansible_control_node.md).
- Why not VirtualBox: odin's 6.1 crashes on boot (VERR_VMM_SET_JMP_ABORTED_RESUME,
  2026-10-16) and is end of life; KVM is part of the kernel.

Tested 2026-10-16: `trading_server.yml` passed (21 ok, 0 failed) and a second run
reported `changed=0`.

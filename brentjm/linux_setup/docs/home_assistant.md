# Home Assistant

Home Assistant OS in a KVM virtual machine on odin (`playbooks/home_assistant.yml`, role `home_assistant`).
Decision and security rules: `odin-home-server` note in the vault (2026-11-14).

```bash
ansible-playbook playbooks/home_assistant.yml --ask-become-pass
```

- **VM:** libvirt, UEFI, 2 vCPU, 4 GB RAM, disk image `/var/lib/libvirt/images/haos.qcow2`, starts at boot.
  Image pinned to HAOS 18.4 (`home_assistant_version`, sha256 checked); Home Assistant updates itself afterwards.
- **Network:** libvirt's NAT network (192.168.122.0/24), VM fixed at 192.168.122.10. odin's own network is not changed.
  The VM cannot reach anything on odin except DHCP and DNS (ufw).
- **Web page:** odin forwards ports 80 and 8123 to the VM (`haos-proxy@80.socket`, `haos-proxy@8123.socket`); ufw allows them from the LAN and `tailscale0` only. HAOS 18.4 redirects 8123 to port 80, so both are needed (found 2026-11-14: with only 8123 forwarded the browser got connection refused).
  The playbook ends with the `firewall` role, which turns ufw on (incoming denied; stored printer and Home Assistant rules apply). The `firewall` role skips the SSH rule where no OpenSSH profile exists (odin). Never publish with Funnel.
- **First time:** open `http://192.168.68.62/` (odin's reserved address; a bare `odin` name only resolves on odin itself), create the admin account, turn on two-step login. No HACS or custom integrations.
- **No libvirt group:** the user is not added (that group is root-equivalent); use `sudo virsh list --all`.
- **Test first on the test VM:** nested KVM works there. Pass `-e home_assistant_ram_mb=2048` (the test VM has 4 GB).

Tested 2026-11-14 in the test VM: VM boots, answers 302 on port 8123 directly and through the forwarder, still works
with ufw on after a restart (DHCP allowed), second run `changed=0`. **Not tested:** internet access from the VM
under ufw on odin, USB devices, Tailscale access, backups, the odin run.

Sources: [HA on Linux (KVM)](https://www.home-assistant.io/installation/linux/),
[HAOS releases](https://github.com/home-assistant/operating-system/releases)

---

# Home Assistant on Proxmox (alternative, not used)

[https://www.home-assistant.io/installation/linux](https://forum.proxmox.com/threads/guide-install-home-assistant-os-in-a-vm.143251/)

Create the VM

General:

- Select your VM name and ID
- Select 'start at boot'

OS:

- Select 'Do not use any media'

System:

- Change 'machine' to 'q35'
- Change BIOS to OVMF (UEFI)
- Select the EFI storage (typically local-lvm)
- Uncheck 'Pre-Enroll keys'

Disks:

- Delete the SCSI drive and any other disks

CPU:

- Set minimum 2 cores

Memory:

- Set minimum 4096 MB

Network:

- Leave default unless you have special requirements (static, VLAN, etc)

        qm importdisk <VM ID> </path/to/file.qcow2> <EFI location>

- Close the node's console and select your HA VM

- Go to the 'Hardware' tab

- Select the 'Unused Disk' and click the 'Edit' button

- Check the 'Discard' box if you're using an SSD then click 'Add'

- Select the 'Options' tab

- Select 'Boot Order' and hit 'Edit'

- Check the newly created drive (likely scsi0) and uncheck everything else

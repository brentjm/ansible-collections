# Home Assistant

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

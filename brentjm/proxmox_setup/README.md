# Proxmox Setup

## Computer setup

- 1 x 128 GB SSD for Proxmox
- 2 x 1 TB drives mirrored
- 1 x 3 TB drive for data

## Installation

Notes:

- Installed on SDD (leaving other drives unformatted)
- Hostname FQDN: Used brentastic.com
- Will get wildcard certs for this domain

Directory structure after installation

    SSD: 128GB installed with Proxmox
    Filesystem            Size  Used Avail Use% Mounted on
    udev                  7.8G     0  7.8G   0% /dev
    tmpfs                 1.6G  1.5M  1.6G   1% /run
    /dev/mapper/pve-root   37G  2.7G   33G   8% /
    tmpfs                 7.8G   46M  7.8G   1% /dev/shm
    tmpfs                 5.0M     0  5.0M   0% /run/lock
    /dev/fuse             128M   16K  128M   1% /etc/pve
    tmpfs                 1.6G     0  1.6G   0% /run/user/0

Disks

    ├/dev/sda  
    │   ├─/dev/sda1  BIOS
    │   ├─/dev/sda2  EFI
    │   └─/dev/sda3  LVM
    ├/dev/sdb
    ├/dev/sdc
    │   ├─/dev/sdc1  ZFS
    │   └─/dev/sdc9  ZFS Reserved
    ├/dev/sdd
    │   ├─/dev/sdd1  ZFS
    │   └─/dev/sdd9  ZFS Reserved

### Ansible Playbook Configuration

bash
    ansible-playbook -i playbooks/inventory.ini playbooks/proxmox.yml

## VM Configuration

### Ubutnu 24.04

default installation

### Home Assistant

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


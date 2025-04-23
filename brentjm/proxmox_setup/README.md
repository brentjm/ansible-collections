# Proxmox Setup

## Overview

Setup the Proxmox server

## Computer setup

- 1 x 128 GB SSD for Proxmox
- 2 x 1 TB drives mirrored
- 1 x 3 TB drive for data

## Installation

### Installation from USB drive

- Created a bootable USB with Balena Etcher
- Installed on SDD (leaving other drives unformatted) using Graphical install
- Hostname FQDN: Used pve.brentastic.com
- Will get wildcard certs for this domain

### Inspecting the installation

One web interface, open >_Shell
Directory structure after installation (`df -h`)

    SSD: 128GB installed with Proxmox
    Filesystem            Size  Used Avail Use% Mounted on
    udev                  7.8G     0  7.8G   0% /dev
    tmpfs                 1.6G  1.5M  1.6G   1% /run
    /dev/mapper/pve-root   37G  2.7G   33G   8% /
    tmpfs                 7.8G   46M  7.8G   1% /dev/shm
    tmpfs                 5.0M     0  5.0M   0% /run/lock
    /dev/fuse             128M   16K  128M   1% /etc/pve
    tmpfs                 1.6G     0  1.6G   0% /run/user/0

### Initial disk listings

Click on `Datacenter -> pve` then `Disks`

    ├/dev/sda  
    │   ├─/dev/sda1  BIOS
    │   ├─/dev/sda2  EFI
    │   └─/dev/sda3  LVM
    ├/dev/sdb
    ├/dev/sdc
    ├/dev/sdd

If disks are already formatted, use one of the following:
(see: [https://www.youtube.com/watch?v=HqOGeqT-SCA](https://www.youtube.com/watch?v=HqOGeqT-SCA))

- ssh (or use Proxmox shell) run:
  - fdisk /dev/sdX
    - `g` to create a new GPT partition table
    - `w` to write the changes
- `wipefs -a /dev/sdX`
- on the GUI, select the disk and click `Wipe Disk`

### Ansible Playbook Configuration

- Tries to configure ssh (work in progress)
  - use `ssh-copy-id -i /home/brent/.ssh/id_rsa.pub root@192.168.68.62`
- Sets up the disks
- Removes the subscription banner

bash
    ansible-playbook -i playbooks/inventory.ini playbooks/proxmox.yml

### Disks after Ansible Playbook

#### Check the Datacenter Disks

Click on `Datacenter -> pve` then `Disks`

    ├/dev/sda  
    │   ├─/dev/sda1  BIOS
    │   ├─/dev/sda2  EFI
    │   └─/dev/sda3  LVM
    ├/dev/sdb
    │   ├─/dev/sdb1  ext4
    ├/dev/sdc
    │   ├─/dev/sdc1  ZFS
    │   └─/dev/sdc9  ZFS Reserved
    ├/dev/sdd
    │   ├─/dev/sdd1  ZFS
    │   └─/dev/sdd9  ZFS Reserved

#### Check the storage configuration

`/etc/pve/storage.cfg`:

    dir: local
        path /var/lib/vz
        content backup,iso,vztmpl

    lvmthin: local-lvm
        thinpool data
        vgname pve
        content images,rootdir


    dir: vm_storage
            path /mnt/vm_pool/vm_storage
            content images
            prune-backups keep-last=1
            shared 0


    dir: rootdir_storage
            path /mnt/vm_pool/rootdir
            content rootdir
            prune-backups keep-last=1
            shared 0


    dir: iso_storage
            path /mnt/data_pool/iso
            content iso
            prune-backups keep-last=1
            shared 0


    dir: vztmpl_storage
            path /mnt/data_pool/vztmpl
            content vztmpl
            prune-backups keep-last=1
            shared 0


    dir: snippets_storage
            path /mnt/data_pool/snippets
            content snippets
            prune-backups keep-last=1
            shared 0


    dir: backup_storage
            path /mnt/data_pool/backup
            content backup
            prune-backups keep-last=1
            shared 0


    dir: general_storage
            path /mnt/data_pool/general
            content none
            prune-backups keep-last=1
            shared 0

#### Confirm status

    root@pve:/mnt# zpool status
      pool: data_pool
     state: ONLINE
    config:

        NAME        STATE     READ WRITE CKSUM
        data_pool   ONLINE       0     0     0
          sdb       ONLINE       0     0     0

    errors: No known data errors

      pool: vm_pool
     state: ONLINE
    config:

        NAME        STATE     READ WRITE CKSUM
        vm_pool     ONLINE       0     0     0
          mirror-0  ONLINE       0     0     0
            sdd     ONLINE       0     0     0
            sdc     ONLINE       0     0     0

    errors: No known data errors

#### Check the ZFS pools

    root@pve:~# zfs list
    NAME                 USED  AVAIL  REFER  MOUNTPOINT
    data_pool           1.08M  2.63T   120K  /mnt/data_pool
    data_pool/backup      96K   500G    96K  /mnt/data_pool/backup
    data_pool/general     96K  1.46T    96K  /mnt/data_pool/general
    data_pool/iso         96K  50.0G    96K  /mnt/data_pool/iso
    data_pool/snippets    96K  10.0G    96K  /mnt/data_pool/snippets
    data_pool/vztmpl      96K  50.0G    96K  /mnt/data_pool/vztmpl
    vm_pool              222K   899G    25K  /mnt/vm_pool
    vm_pool/rootdir       24K   200G    24K  /mnt/vm_pool/rootdir
    vm_pool/vm_storage    24K   600G    24K  /mnt/vm_pool/vm_storage

## VM Installation

- Upload the ISO to the Proxmox server (data_pool/iso)
- Create a VM
  - General Tab
    - Select the VM name and ID
    - Select 'start at boot'
  - OS Tab
    - Select the ISO image
  - System Tab
    - Select 'Qemu Agent'
  - Disks Tab
    - Select the disk size (minimum 32 GB)
    - Select the storage location (vm_pool/vm_storage)
  - CPU Tab
    - Set minimum 2 cores
  - Memory Tab
    - Set minimum 4096 MB
  - Network Tab
    - Leave default unless you have special requirements (static, VLAN, etc)
  - Confirm the settings

### Ubutnu 24.04

default installation

See: Linux Setup Ansible playbook for configuration

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


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

## Ansible Playbook Configuration

bash
    ansible-playbook -i playbooks/inventory.ini playbooks/proxmox.yml


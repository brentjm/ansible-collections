# Ansible Playbooks for Linux Setup

## Table of Contents

- [About](#about)
- [workstation](#workstation)
- [server](#server)

## About

Playbooks to help set up workstations and servers. The workstation playbook is
focused on setting up a Linux workstation for development work. The server
playbook is focussed on setting up VMs and LXCs on a Linux server for home lab
(like a Proxmox server).

## Workstation

This playbook is intended to build a development station. The order of installation
is:

- Install the OS on the local computer manually.
- Use remote computer to run the Ansible playbook.
  - Set the correct IP address in the `inventory` file ([linux_setup/playbooks/inventory.ini](../playbooks/inventory.ini)).

    ```ini
    [home_servers]
    frigg ansible_host=192.168.68.52 ansible_user=brent ansible_ssh_private_key_file=/home/brent/.ssh/id_rsa
    ```

  - Create the Ansible Vault file with the SSH private key([linux_setup/roles/workstation/vars/vault.yml](../roles/ssh/vars/vault.yml)).

    `vault.yml` file should look like this:

    ```yaml
      ansible_ssh_key_passphrase: your-secure-passphrase
    ```

    Then encrypt the file using Ansible Vault:

    ```bash
      ansible-vault encrypt roles/ssh/vars/vault.yml
    ```

### install Git related tools

- Use package manager to install Git
- Create ssh key pair
  - This requires using Ansible Vault to store the private key

### install Python related tools

In particular need pylsp for Neovim LSP.

- miniconda []


### install other tools
- Docker
- Neovim
  - Use the Neovim repo for setting up LSP, ...
- Nerdfonts
- Lazygit
- Languates
  - NodeJS
  - Python
    - Was using Anaconda, but may switch to Poetry
  - Golang
- Snaps
- LaTeX

## Server

This playbook is used to install all the services for the Home Lab.

- [Ubuntu](./ubuntu.md)
- [Home Assistant](./home_assistant.md)

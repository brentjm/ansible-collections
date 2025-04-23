# Setup Home Ubuntu Server

This will help setup the server with Plex, Home Assistant, and other.

## Usage

bash
    ansible-playbook -i playbooks/inventory.ini playbooks/workstation.yml --ask-become-pass

## TODO

- Use Ansible Vault to hold the host machine login, since it is needed on the
first pass to setup SSH
- Configure portainer certificate

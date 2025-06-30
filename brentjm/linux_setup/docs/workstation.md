# Workstation

This playbook is intended to build a development station, such as a laptop or desktop
for individual use. Typical applications include:

- Version control (Git)
- Programming languages (Python, NodeJS, Go, etc.)
- IDEs (Neovim, VSCode, etc.)
- Docker
- Modelling tools (Blender, GIMP, Inkscape, etc.)
- Virtualization (VirtualBox, Vagrant, etc.)
- Other tools (LaTeX, Obsidian, etc.)

## Getting Started

### Pre-work steps on the workstation

These steps need to be done manually before Ansible can be used from a control node
to set up the workstation.

- Install the OS.
- Install and make sure openSSH is running.

  ```bash
  sudo apt install openssh-server
  sudo systemctl enable ssh
  sudo systemctl start ssh
  ```

### Preparing the Ansible control node

#### Check inventory file

Set the correct IP address in the `inventory` file
([linux_setup/playbooks/inventory.ini](../playbooks/inventory.ini)).

  ```ini
  [home_servers]
  frigg ansible_host=192.168.68.64 ansible_user=brent ansible_ssh_private_key_file=/home/brent/.ssh/id_rsa_ansible
  ```

#### Check the Ansible variables

The variables contain information like the download URLs for some of the tools
and the paths where they will be installed. These variables are defined under
the roles directories.

([linux_setup/playbooks/workstation/vars/main.yml](../roles/workstation/vars/main.yml)).

### Run the Ansible playbooks

```bash
ansible-playbook playbooks/workstation.yml -i inventory.ini --ask-vault-pass --ask-pass --ask-become-pass
```

To debug the playbook, you can run it with the `-vvv` option to get more verbose output:

### install Git related tools

- Use package manager to install Git
- Create ssh key pair
  - This requires using Ansible Vault to store the private key

### install Python related tools

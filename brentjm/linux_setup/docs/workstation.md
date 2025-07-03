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

To run the playbook, use the following command from the control node (use the
-vvv flag for verbose output):

```bash
ansible-playbook playbooks/workstation.yml -i inventory.ini --ask-vault-pass --ask-pass --ask-become-pass
```

To help debug a task, first add a `tags` to the specific task in the playbook,
then run the `debug` playbook with the `--tags` option.  For example:

```yaml
    - name: Update fonts
      ansible.builtin.shell: fc-cache -f -v
      tags: debug
```

```bash
ansible-playbook playbooks/debug.yml -i inventory.ini --tags "debug"
```

### Post installation steps

- The `nautilus-dropbox` pakckage will propt a dialog that will download and
install the Dropbox client, and sign into the Dropbox account. Follow the
instructions to complete the installation.
- In Gnome settings, open online accounts and add your Google account.

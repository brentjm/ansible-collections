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

**Targets Ubuntu 26.04.** Some packages (apt `lazygit`, `dotnet-sdk-10.0`, `libfuse2t64`) are not in 22.04, so run this on odin only after its upgrade.

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

Check the groups in the inventory file
([linux_setup/inventory.ini](../inventory.ini)). Each playbook targets one group:

  ```ini
  [trading]        # trading_server.yml only
  frigg ansible_host=192.168.68.55 ansible_user=brent ansible_ssh_private_key_file=/home/brent/.ssh/id_ed25519

  [workstations]   # workstation.yml
  odin ansible_connection=local

  [home_servers]   # server.yml, debug.yml
  odin ansible_connection=local
  ```

#### Check the Ansible variables

Download URLs and versions are in
[roles/workstation/defaults/main.yml](../roles/workstation/defaults/main.yml).
`username` and the timezone are in [group_vars/all.yml](../group_vars/all.yml).
Override any default in `group_vars/workstations.yml`.

### Run the Ansible playbooks

Run from `brentjm/linux_setup` (add `-vvv` for verbose output). odin is in the
inventory with a local connection, so this runs on odin itself:

```bash
ansible-playbook playbooks/workstation.yml --ask-become-pass
```

Each step has a tag (list in
[roles/workstation/tasks/main.yml](../roles/workstation/tasks/main.yml)), plus
`docker` and `firewall`:

```bash
ansible-playbook playbooks/workstation.yml --ask-become-pass --tags signal
ansible-playbook playbooks/workstation.yml --ask-become-pass --skip-tags latex,snaps
```

Test on the Vagrant VM first: see [testing.md](testing.md).

### Post installation steps

- The `nautilus-dropbox` pakckage will propt a dialog that will download and
install the Dropbox client, and sign into the Dropbox account. Follow the
instructions to complete the installation.
- In Gnome settings, open online accounts and add your Google account.

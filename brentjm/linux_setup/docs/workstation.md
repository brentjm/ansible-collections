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
  frigg ansible_host=192.168.68.61 ansible_user=brent ansible_ssh_private_key_file=/home/brent/.ssh/id_ed25519

  [workstations]   # workstation.yml
  odin ansible_connection=local

  [home_servers]   # server.yml, debug.yml
  odin ansible_connection=local
  ```

#### Check the Ansible variables

Download URLs and versions are in each role's `defaults/main.yml`
(e.g. [roles/neovim/defaults/main.yml](../roles/neovim/defaults/main.yml)).
`username` and the timezone are in [group_vars/all.yml](../group_vars/all.yml).
Override any default in `group_vars/workstations.yml`.

### Run the Ansible playbooks

Run from `brentjm/linux_setup` (add `-vvv` for verbose output). odin is in the
inventory with a local connection, so this runs on odin itself:

```bash
ansible-playbook playbooks/workstation.yml --ask-become-pass
```

The roles listed in [playbooks/workstation.yml](../playbooks/workstation.yml)
are the workstation's software, one role per application. Each role's tag is
its name:

```bash
ansible-playbook playbooks/workstation.yml --ask-become-pass --tags signal
ansible-playbook playbooks/workstation.yml --ask-become-pass --skip-tags latex,snaps
```

Test on the KVM VM first: see [testing.md](testing.md).

### Post installation steps

- Dropbox: run `dropbox start -i`, then open the link it prints to sign in.
  Dropbox Basic allows 3 devices; unlink the old machine first at
  dropbox.com > Settings > Security. The "restart Nautilus" message from the
  old file-manager add-on can be closed; syncing works without it.
- KeePassXC: open `~/Dropbox/infoBase` with the key file the role copies to
  `~/.local/share/keepassxc/infoClavis`.
- In Gnome settings, open online accounts and add your Google account.

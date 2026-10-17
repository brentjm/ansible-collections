# Setup the Ansible control node to run the playbooks

The control node is odin. Targets run Ubuntu 26.04 (Python 3.14), which needs
**ansible-core 2.20 or newer**; 2.20+ itself needs Python 3.12+ on the control
node (see the [support matrix](https://docs.ansible.com/ansible/latest/reference_appendices/release_and_maintenance.html)).

- Install Ansible with uv, which fetches a suitable Python even if the system
  Python is older (odin's Ubuntu 22.04 has 3.10):

  ```bash
  pipx uninstall ansible        # if the older pipx install exists
  uv tool install --managed-python --python 3.13 --with bcrypt ansible   # uv-managed Python, not conda
  ansible --version             # core 2.20+ expected
  ```

- Install the collections the roles use (listed in `requirements.yml`):

  ```bash
  cd brentjm/linux_setup
  ansible-galaxy collection install -r requirements.yml
  ```

## Project layout

Plain Ansible project (not a Galaxy collection); run everything from
`brentjm/linux_setup`. `ansible.cfg` there sets the inventory and roles path, so
no `-i` is needed.

| Path | Holds |
| --- | --- |
| `inventory.ini` | Machines and groups (`trading`, `workstations`, `home_servers`) |
| `group_vars/all.yml` | Settings for every machine (`username`, timezone) |
| `group_vars/<group>.yml` | Per-group overrides (create when needed) |
| `roles/<name>/defaults/main.yml` | Each role's default settings |
| `roles/` | `base`, `docker`, `firewall`, `claude_code`, `tailscale`, `workstation`, `server` |
| `playbooks/` | One per machine type; each is a list of roles with tags |
| `test/` | Vagrant VM for testing, see [testing.md](testing.md) |

## Conventions

- Playbooks never set `become`; each task that needs root says `become: true`.
- Every role in a playbook has a tag, and the workstation steps each have one,
  so `--tags` / `--skip-tags` run or skip parts.

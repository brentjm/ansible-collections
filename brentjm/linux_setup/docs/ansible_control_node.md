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

- Collections used: `community.general`, `community.crypto`, `community.docker`,
  `ansible.posix` (included in the `ansible` package).

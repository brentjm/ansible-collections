# Testing in a throwaway VM

`test/` holds a Vagrant VM (Ubuntu 26.04, VirtualBox) and an inventory that puts
it in every group, so any playbook can run against it instead of frigg or odin.

```bash
cd brentjm/linux_setup/test
vagrant up                      # first run downloads bento/ubuntu-26.04 (~1 GB)
cd ..
ansible-playbook -i test/inventory.ini playbooks/trading_server.yml
ansible-playbook -i test/inventory.ini playbooks/workstation.yml --skip-tags latex
ansible-playbook -i test/inventory.ini playbooks/trading_server.yml   # again: should report changed=0 or close
cd test && vagrant destroy -f   # throw it away
```

- The VM user is `vagrant` with passwordless sudo, so no `--ask-become-pass`.
- `username=vagrant` is a host variable in `test/inventory.ini`; it overrides
  `group_vars/all.yml` (linked into `test/`).
- Needs ansible-core 2.20+ like frigg (Python 3.14 in the VM), see
  [ansible_control_node.md](ansible_control_node.md).
- Snapshot before a risky change: `vagrant snapshot save clean`, then
  `vagrant snapshot restore clean`.

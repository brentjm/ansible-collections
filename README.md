# Ansible collections

## Playbooks

- [Linux setup](./brentjm/linux_setup/docs/toc.md) (plain Ansible project)
- [Proxmox setup Ansible collection](./brentjm/proxmox_setup/docs/toc.md)

## Install

Linux setup is a plain project: clone the repo and run from
`brentjm/linux_setup` (see its
[control node setup](./brentjm/linux_setup/docs/ansible_control_node.md)).

Proxmox setup is still a collection:

```bash
    ansible-galaxy collection install git+https://github.com/brentjm/ansible-collections.git
```

## Usage

```bash
    cd brentjm/linux_setup
    ansible-playbook playbooks/workstation.yml --ask-become-pass
```

See the Ansible playbook documentation for more details on how to run specific
playbooks.

## TODO

- Use Ansible Vault to hold the host machine login, since it is needed on the
first pass to set up SSH
- Configure Portainer certificate

## Authors

Brent Maranzano

## License

This project is licensed under the MIT License - see the [LICENSE](./LICENSE)
file for details.

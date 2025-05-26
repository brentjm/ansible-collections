# Ansible collections

## Playbooks

- [Linux setup Ansible collection](./brentjm/linux_setup/docs/toc.md)
- [Proxmox setup Ansible collection](./brentjm/proxmox_setup/docs/toc.md)

## Install

To install the Ansible collection, run the following command:

```bash
    ansible-galaxy collection install git+https://github.com/brentjm/ansible-collections.git
```

## Usage

```bash
    ansible-playbook -i playbooks/inventory.ini playbooks/workstation.yml --ask-become-pass
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

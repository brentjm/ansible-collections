# SSH

The `ssh` playbook and role are used to set up SSH on a Linux workstation.
It should be used as a template and customized for specific needs and provide
a record of the detail changes.

## Creating Ansible Vault to store private data

If the SSH key pair is locked with a passphrase, it should be stored in an
Ansible Vault file for security.

([linux_setup/roles/workstation/vars/vault.yml](../roles/ssh/vars/vault.yml)).

`vault.yml` file should look like this:

```yaml
  vault_ssh_key_passphrase: your-secure-passphrase
```

Then encrypt the file using Ansible Vault:

```bash
  ansible-vault encrypt roles/ssh/vars/vault.yml
```

## Adding the SSH key to the SSH agent

Keys can be added to the SSH agent to allow for easier authentication. The
command to add the SSH key is:

  ```bash
  ssh-add ~/.ssh/id_rsa_ansible
  ```

There is an ansible playbook to automate much of the SSH setup. The `ssh` role
can be configured to do this as well and provide a record of the change. See
the tasks in
[linux_setup/roles/ssh/tasks/main.yml](../roles/ssh/tasks/main.yml).

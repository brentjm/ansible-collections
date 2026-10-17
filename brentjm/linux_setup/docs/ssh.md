# SSH

`playbooks/ssh_setup.yml` (two plays, no role):

1. On the control node (odin): creates `~/.ssh/id_ed25519` with the passphrase
   from Ansible Vault. Never replaces an existing key, so it is safe to rerun.
   Needed after a clean rebuild of odin; an in-place upgrade keeps `~/.ssh`.
2. On every other host in the inventory: adds the public key to
   `authorized_keys`.

```bash
ansible-playbook playbooks/ssh_setup.yml --ask-vault-pass --ask-pass
```

`--ask-pass` (login password, uses `sshpass`) is only needed while a host does
not yet have the key.

## Vault file

`playbooks/vars/vault.yml` (git-ignored) holds:

```yaml
vault_ssh_key_passphrase: your-secure-passphrase
```

Create or edit it with:

```bash
ansible-vault create playbooks/vars/vault.yml
ansible-vault edit playbooks/vars/vault.yml
```

## SSH agent

The key has a passphrase, so load it once per session:

```bash
ssh-add ~/.ssh/id_ed25519
```

# Trading server (frigg)

Dedicated box for the trading container and a Claude Code session for its code.
Nothing else is installed, to keep it stable.

## Run

```bash
cd brentjm/linux_setup
ansible-playbook playbooks/trading_server.yml --ask-become-pass
ansible-playbook playbooks/trading_server.yml --ask-become-pass --tags docker   # one part only
```

Test on the Vagrant VM first: see [testing.md](testing.md).

## What it does

| Role (tag) | Detail |
| --- | --- |
| `base` | Timezone (`base_timezone`, America/New_York in `group_vars/all.yml`; the cron uses market time), grow root LV to the whole disk, dist-upgrade, `base_packages`, unattended upgrades never reboot |
| `docker` | Docker apt repo, engine, compose; `username` in the `docker` group |
| `tailscale` | Commented out: Claude Remote Control needs no inbound access |
| `firewall` | UFW: deny incoming, allow OpenSSH |
| `claude_code` | Native installer for `username` |

## Manual afterwards

- `claude` on frigg to log in
- `sudo reboot` if the play reports a reboot is required
- Move the trader container and cron from odin (disable odin's cron first)

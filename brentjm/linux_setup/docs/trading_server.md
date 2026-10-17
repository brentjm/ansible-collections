# Trading server (frigg)

Dedicated box for the trading container and a Claude Code session for its code.
Nothing else is installed, to keep it stable.

## Run

```bash
cd brentjm/linux_setup
ansible-playbook -i inventory.ini playbooks/trading_server.yml --ask-become-pass
```

## What it does

| Step | Task file | Detail |
| --- | --- | --- |
| Base | `roles/server/tasks/base.yml` | Timezone America/New_York (cron uses market time), grow root LV to the whole disk, dist-upgrade, base packages, unattended upgrades never reboot |
| Docker | `roles/server/tasks/docker.yml` | Docker apt repo, engine, compose; user in `docker` group |
| Tailscale | `roles/server/tasks/tailscale.yml` | Commented out: Claude Remote Control needs no inbound access |
| Firewall | `roles/server/tasks/firewall.yml` | UFW: deny incoming, allow OpenSSH and tailscale0 |
| Claude Code | `roles/server/tasks/claude_code.yml` | Native installer for the user |

## Manual afterwards

- `claude` on frigg to log in
- `sudo reboot` if the play reports a reboot is required
- Move the trader container and cron from odin (disable odin's cron first)

# Obsidian in a browser (odin)

Runs the real Obsidian (Dataview, Tasks) in a container and shows it in a browser, so the
phone can see the vault's summaries. `playbooks/obsidian_web.yml`: roles `docker`, `tailscale`, `obsidian_web`.

```bash
ansible-playbook playbooks/obsidian_web.yml --ask-become-pass
sudo tailscale up                     # once; approve the printed URL
# Tailscale admin console > DNS: enable MagicDNS and HTTPS certificates
ansible-playbook playbooks/obsidian_web.yml --ask-become-pass --tags obsidian_web   # publishes to the tailnet
```

- Image: `lscr.io/linuxserver/obsidian` (KasmVNC). Container port 3001 is bound to `127.0.0.1`
  (Docker bypasses ufw for published ports); `tailscale serve` publishes it as
  `https://<odin MagicDNS name>:8443`, tailnet only. Never enable Funnel.
- Login: user `brent`, password in `~/.config/obsidian_web/password` (made on first run, not in git).
- The container mounts the vault at `/vault` and has a passwordless root terminal in the UI.
  Anyone who gets in can edit every note, so keep the password and the tailnet closed.
- First visit: open folder `/vault`, then trust plugins. Plugins live in the vault's `.obsidian`.
- HTTPS certificates put the machine name in the public Certificate Transparency log.

Tested 2026-10-25 in the test VM: container up, 401 without password, 200 with it, vault
mounted, second run `changed=0`. **Not tested:** `tailscale serve`, the Obsidian UI, phone use.

Sources: [linuxserver/obsidian](https://docs.linuxserver.io/images/docker-obsidian/),
[KasmVNC base image](https://docs.linuxserver.io/images/docker-baseimage-kasmvnc/),
[Tailscale HTTPS](https://tailscale.com/docs/how-to/set-up-https-certificates),
[tailscale serve](https://tailscale.com/docs/reference/tailscale-cli/serve).

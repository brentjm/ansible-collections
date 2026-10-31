# Printer server (odin)

Shares the HP LaserJet P1102w (USB on odin) to the house with CUPS. `playbooks/printer.yml`: role `printer`
(and `tailscale` with `--tags tailscale`).

```bash
ansible-playbook playbooks/printer.yml --ask-become-pass
lp -d HP-LaserJet-Professional-P-1102w /usr/share/cups/data/testprint   # test page
```

- Packages: `cups`, `avahi-daemon`, `libnss-mdns`, `cups-ipp-utils` (`ippfind`), `hplip`, `hplip-gui`, `printer-driver-hpcups`.
- **HP plugin** (`plugin=1` in hplip's `models.dat`; hpcups uses its `lj.so`): must match the hplip version.
  The role uses the saved copy on `data_pool` (`printer_plugin_dir`), else downloads it from OpenPrinting,
  checks it against `printer_plugin_sha256`, and runs `yes y | hp-plugin -i -p <file>` (HP's license prompt).
  No `pipefail` there: `yes` always exits on SIGPIPE; the task after it checks `/var/lib/hp/hplip.state`.
  When Ubuntu updates hplip the role stops and asks for the new file's checksum: download the `.run` and
  `.asc`, check the signature (HPLIP key ID `73D770CDA59047B9`), save both on `data_pool`, add the sha256.
- **cupsd.conf** (four edits, rest stays Ubuntu's default): `Port 631` instead of `Listen localhost:631`,
  `ServerAlias *` (so `odin`, `odin.local` and the Tailscale name are accepted), `Browsing Yes`, and
  `Allow from @LOCAL`, `100.64.0.0/10`, `fd7a:115c:a1e0::/48` in `<Location />`. Admin pages stay localhost-only.
  `@LOCAL` alone does not cover tailnet peers: `tailscale0` carries a /32.
- Queue `HP-LaserJet-Professional-P-1102w`, `hp:/usb/...` URI, PPD `drv:///hpcups.drv/hp-laserjet_professional_p_1102w.ppd`,
  shared. Created only if missing.
- ufw: 631/tcp and 5353/udp from `192.168.68.0/22`. Stored even while ufw is off; `tailscale0` is opened by the
  `tailscale` role.

## Clients
Advertised by DNS-SD (with the AirPrint `_universal` subtype) as
**`Hewlett-Packard HP LaserJet Professional P 1102w @ odin`**. Pick that entry, never one without
`@ odin`: the printer's own Wi-Fi (setup signal, Wi-Fi Direct) also shows up and asks for a PIN.
- **Windows**: Settings → Printers & scanners → Add device → the `@ odin` entry; Windows installs its
  Microsoft IPP Class Driver, no HP software. Fallback: Add manually → shared printer by name
  `http://odin.local:631/printers/HP-LaserJet-Professional-P-1102w` (or `192.168.68.62` for `odin.local`).
- **iPhone** (AirPrint), **Android** (Default Print Service / Mopria), Linux, macOS: found automatically.
- **Outside the house (Tailscale)**: no discovery over the tailnet; add
  `ipp://<odin MagicDNS name>:631/printers/HP-LaserJet-Professional-P-1102w` by hand.

## Trouble
- `hp-doctor`, `lpstat -t`, `journalctl -u cups`, `/var/log/cups/error_log` (set `LogLevel debug` to see more).
- Job sits "processing" with nothing printed → plugin missing or wrong version: `cat /var/lib/hp/hplip.state`.
- Not found → `ippfind -T 5` on odin should list `ipp://odin.local:631/printers/...`; check the client is on the house Wi-Fi
  (Deco guest network and device isolation block mDNS).
- Wi-Fi on the printer itself is not used (unreliable); USB only. `hp-wificonfig` cannot set it up over USB:
  the LEDM request (`GET /IoMgmt/Adapters`) gets no answer and hangs, the older XML method gives
  "Device I/O error" (hplip 3.24.4, 2026-10-31).

Tested on odin 2026-10-31: plugin installed (3.24.4), CUPS on `*:631`, printer page HTTP 200 at
`192.168.68.62`, `ippfind` sees the share, Windows found and installed it.
**Not tested:** iPhone, Android, Tailscale, ufw on.

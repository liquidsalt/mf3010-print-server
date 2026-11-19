# mf3010-print-server

Shares a USB Canon MF3010 on the local network so phones and laptops find it like a Wi-Fi printer (AirPrint / IPP Everywhere).

## Needs on the host

- Podman (rootful), x86_64
- `avahi-daemon` running with user service publishing allowed (NixOS: `services.avahi.publish.enable` and `publish.userServices`)
- No CUPS of its own on port 631
- Firewall open on the home Wi-Fi interface: TCP 631, UDP 5353
- No suspend while it should be reachable (e.g. lid closed)

## Run

```sh
sudo podman build -t mf3010-print-server .
sudo cp mf3010.container /etc/containers/systemd/
sudo systemctl daemon-reload
sudo systemctl start mf3010
```

It starts at boot from then on. The queue is created once the printer is switched on and plugged in.
Logs: `journalctl -u mf3010`

# Installation

## Linux

The supported quick installation path is:

```bash
bash <(curl -Ls https://raw.githubusercontent.com/erfanghobadi2000/sing-ui/main/install.sh)
```

The installer requires root privileges and installs a systemd service named `sing-ui`.

After installation:

```systemctl status sing-ui --no-pager
journalctl -u sing-ui -e --no-pager
```

Open:

```
http://SERVER_IP:2095/app/
```

S-UI's default installation credentials are `admin / admin`. Change the password immediately after the first login.

## Build from source

```bash
git clone https://github.com/erfanghobadi2000/sing-ui.git
cd sing-ui
bash scripts/build.sh
```

## Updating

```bash
sudo /usr/local/src/sing-ui/scripts/update.sh
```

## Uninstalling

```bash
sudo /usr/local/src/sing-ui/scripts/uninstall.sh
```

The uninstall script removes the service and launcher but deliberately leaves the source and database directory in place.

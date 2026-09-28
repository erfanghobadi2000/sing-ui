# Sing-UI

A Sing-Box based panel with a modern UI inspired by the visual language of 3X-UI.

## Architecture

- **Core/backend:** S-UI by alireza0
- **Engine:** SagerNet/sing-box through S-UI
- **Frontend:** S-UI frontend, restyled and reorganized with a 3X-UI-inspired desktop/mobile shell
- **Upstream references:** MHSanaei/3x-ui and alireza0/s-ui

The core is intentionally kept on the S-UI side. This project does not replace Sing-Box with Xray.

## One-command installation

```bash
bash <(curl -Ls https://raw.githubusercontent.com/erfanghobadi2000/sing-ui/main/install.sh)
```

For a controlled version:

```bash
curl -fsSL https://raw.githubusercontent.com/erfanghobadi2000/sing-ui/main/install.sh | sudo bash -s -- --version v0.1.0
```

## What the installer does

1. Detects the Linux distribution and CPU architecture.
2. Installs build/runtime dependencies when required.
3. Downloads the S-UI source and its official frontend submodule.
4. Applies the Sing-UI visual layer.
5. Builds the frontend and the S-UI backend.
6. Installs a systemd service.
7. Prints the panel URL and the generated/default credentials returned by S-UI.

## Developer build

```bash
git clone --recurse-submodules https://github.com/erfanghobadi2000/sing-ui.git
cd sing-ui
./scripts/build.sh
```

## Repository layout

```
patches/                 UI overrides applied to S-UI frontend
scripts/                 build/install/update helpers
upstream/s-ui            downloaded S-UI build tree (created by scripts/build.sh)
patches/                Sing-UI presentation overrides
```

## Status

This repository is the integration layer. Upstream S-UI remains the source of truth for Sing-Box functionality, protocol support, subscriptions, database schema, and operational behavior. The custom layer focuses on presentation and integration safety.

## License

GPL-3.0-or-later. Upstream license and attribution notices are preserved through the included submodules.

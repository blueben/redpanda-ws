# redpanda-ws

Ansible-based workstation automation for Linux (CachyOS/Arch) and macOS.

## Quick Start

```bash
# Fresh machine — bootstrap installs dependencies and runs the playbook
./bootstrap.sh

# Existing machine — run directly
ansible-playbook site.yml

# Run specific roles
ansible-playbook site.yml --tags base,dev

# Dry run
ansible-playbook site.yml --check --diff
```

## Roles

| Role | Description |
|------|-------------|
| `base` | Core CLI tools (git, curl, ripgrep, fd, jq, fzf, etc.) |
| `dev` | Development toolchains (node, python, go, rust, cmake) |
| `aur` | AUR helper (paru) and AUR packages (Arch Linux only) |
| `sysctl` | Kernel/system tuning parameters |
| `chezmoi` | Dotfile management via chezmoi |
| `atuin` | Shell history sync with atuin |

## Tags

| Tag | Selects |
|-----|---------|
| `base`, `dev`, `aur`, `sysctl`, `chezmoi`, `atuin` | All tasks in that role |
| `packages` | Package install tasks across base/dev/aur |
| `dotfiles` | chezmoi init + apply |
| `services` | Service enable/start tasks |
| `tuning` | sysctl settings |
| `install` | Binary install steps |
| `config` | Config file deployments |

## Chezmoi

Pass your dotfiles repo URL:

```bash
ansible-playbook site.yml --tags chezmoi -e chezmoi_repo_url=https://github.com/you/dotfiles
```

## Verification

```bash
./scripts/verify.sh
```

## License

MIT License — Copyright (c) 2026 Benjamin Krueger.

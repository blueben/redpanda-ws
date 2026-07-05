# 🧭 Core Objective

Build a **cross-platform system management framework** that:

* Keeps Linux (CachyOS) and macOS systems **functionally aligned**
* Supports both **adhoc interaction** and **fully automated convergence**
* Makes machines **reproducible, replaceable, and version-controlled**

---

# 🧱 1. Platform Support Requirements

### Must support:

* Linux (Arch-based, specifically CachyOS)
* macOS (Darwin)

### Must abstract:

* Package managers:

  * `pacman` (Linux)
  * `brew` (macOS)
* Service systems:

  * `systemd` (Linux)
  * `launchd` or equivalent (macOS)
* System tuning mechanisms:

  * `sysctl` (both, with different semantics)

👉 Requirement:

> A single codebase with **OS-aware conditional execution**, not parallel implementations.

---

# ⚙️ 2. State Management Model

### Must be:

* Declarative
* Idempotent
* Modular

Roles must be cleanly separated, for example:

* base (core system packages + services)
* dev (tooling)
* aur (Linux-only extensions)
* sysctl (system tuning)
* chezmoi (dotfiles)
* atuin (shell history)

👉 Requirement:

> Use a role-based architecture where each role owns a well-defined slice of system state.

---

# 📦 3. Package Management Abstraction

### Linux (CachyOS)

* pacman for official repos
* AUR via paru/yay

### macOS

* Homebrew (formula + cask)

👉 Requirements:

* Unified logical package definitions
* OS-specific resolution layer, e.g.:

```yaml
packages:
  linux: [...]
  macos: [...]
```

* AUR support must:

  * Install helper (paru/yay)
  * Install packages idempotently

---

# 🧠 4. Configuration & Dotfiles

### Chezmoi is the source of truth

Must:

* Install chezmoi
* Initialize from a git repo
* Apply configuration idempotently

Must not:

* Embed personal config directly in system automation

👉 Requirement:

> Separate **system state (Ansible)** from **user state (chezmoi)**.

---

# ⌨️ 5. Shell & History (Atuin)

Must:

* Install atuin
* Enable regular background sync

### Linux:

* systemd user timer

### macOS:

* launchd agent or equivalent fallback

👉 Requirement:

> Provide **cross-platform synchronization behavior**, implemented differently per OS but consistent in outcome.

---

# 🧪 6. System Tuning (sysctl)

### Must:

* Define tuning centrally
* Apply safely per OS

### Linux:

* `/etc/sysctl.d/*.conf`
* `sysctl --system`

### macOS:

* Limited sysctl support
* Apply only valid keys

👉 Requirement:

> System tuning must be **controlled, portable, and OS-filtered**.

---

# 🔌 7. Service Management

### Linux:

* systemd (enable + start)

### macOS:

* launchd or no-op abstraction

👉 Requirement:

> Define services declaratively and apply them through an **OS-aware service layer**.

---

# 🔁 8. Workflow Requirements

### Must support:

#### Bootstrap

* Minimal manual setup
* Install ansible + git → run playbook

#### Iteration

* Partial execution via tags:

  * `--tags base`
  * `--tags aur`

#### Convergence

* Re-running restores intended state

👉 Requirement:

> The system must support **repeatable convergence and surgical updates**.

---

# 🧩 9. Extensibility

Must allow easy addition of:

* New package sets
* Additional roles
* Secrets management (future)
* Backup/snapshot hooks

👉 Requirement:

> Architecture must remain **loosely coupled and composable**.

---

# 🧠 10. Philosophy (the actual invariant)

What you’re building is:

> A declarative control plane for mutable operating systems.

Which implies:

* State lives in git
* Machines are disposable
* Configuration is intentional
* Drift is corrected, not tolerated

---

# 🧾 Final Condensed Requirements

The system must:

1. Support **Linux (CachyOS) and macOS** with OS-aware execution
2. Be **declarative and idempotent**
3. Use **modular roles**:

   * base, dev, aur, sysctl, chezmoi, atuin
4. Abstract **package management** across pacman and Homebrew
5. Use **chezmoi as the source of truth for user configuration**
6. Provide **atuin with automated sync**, cross-platform
7. Manage **sysctl tuning safely per OS**
8. Abstract **service management** across systemd and launchd
9. Support **partial runs and full convergence workflows**
10. Be **extensible without restructuring core logic**



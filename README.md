# NixOS Multi-Host Architecture & System Configuration

A modular, flake-based **NixOS** and **Home Manager** config for multi-host deployment (`NixHome`, `NixPrecision`, `NixThinkpad`, and a custom bootable `ISO`). This repository implements custom module abstraction layers, dual-channel package pinning (unstable core with pinned stable fallback), dotfile symlinking/management, and cross-desktop environment support (Hyprland, Niri, KDE Plasma, GNOME).

---

## Overview & Architecture

The configuration is structured as an extensible multi-host NixOS workspace with unified entrypoints and localized host profiles.

```
~/nixos-config
├── flake.lock
├── flake.nix                     <-- Root Flake file
├── README.md                     <-- Documentation
├── hosts/                        <-- Host-specific hardware & profiles
│   ├── NixHome/                  <-- Main Desktop
│   ├── NixPrecision/             <-- Workstation Laptop
│   └── NixThinkpad/              <-- Portable Laptop
├── modules/                      <-- Global declarative abstractions
│   ├── home-manager/             <-- Home Manager wrapper
│   └── system/                   <-- Modular system-level feature flags & profiles
│       ├── apps.nix
│       ├── boot.nix
│       ├── core.nix
│       ├── default.nix
│       ├── desktop.nix
│       ├── env.nix
│       ├── fonts.nix
│       ├── gaming.nix
│       ├── hardware.nix
│       ├── packages.nix
│       ├── services.nix
│       ├── users.nix
│       └── virtualisation.nix
└── users/                        <-- User-space configuration
    └── rayu/
        ├── dotfiles/             <-- Raw dotfiles
        ├── alacritty.nix
        ├── apps.nix
        ├── default.nix
        ├── dev.nix
        ├── gaming.nix
        ├── git.nix
        ├── hyprland.nix
        ├── mime.nix
        ├── niri.nix
        ├── nvim.nix
        ├── office.nix
        ├── packages.nix
        ├── services.nix
        ├── theme.nix
        └── zsh.nix
```

---

## Flake Architecture & Output Pipeline (`flake.nix`)

The root `flake.nix` serves as the primary system registry and central dependency manager.

### 1. External Inputs (`flake.nix`)
The system manages multiple upstream repositories and external flakes:
* **`nixpkgs`**: Tracks `nixos-unstable` for rolling updates, latest kernels, and cutting-edge packages.
* **`nixpkgs-stable`**: Tracks `nixos-26.05` to provide stable package fallbacks and pinned runtime stability where needed.
* **`home-manager`**: Tracks home-manager unstable, pinned to match main `nixpkgs`.
* **`nixos-hardware`**: Hardware-specific kernel and module tune-ups for vendor hardware profiles.
* **`kapsule`**: Custom graphical container engine input created by me (`github:cshah25/kapsule`).
* **`hyprland`**: Upstream Hyprland Wayland compositor development builds.
* **`zen-browser`**: Zen Browser flake integration following main `nixpkgs`.
* **`nix-flatpak`**: Declarative Flatpak management module.

### 2. Flake Special Arguments (`specialArgs`)
Every system target evaluated via `nixpkgs.lib.nixosSystem` inherits custom context variables:
```nix
specialArgs = {
  inherit inputs pkgs-stable;
  hostname = "<HostIdentifier>";
};
```
This enables sub-modules across system and user spaces to reference `pkgs-stable` or `inputs.zen-browser` without re-importing upstream flakes manually.

### 3. Defined System Configurations
* **`NixHome`**: Primary workstation. Evaluates `./modules/system`, `./modules/home-manager`, and `./hosts/NixHome`.
* **`NixPrecision`**: Mobile workstation profile.
* **`NixThinkpad`**: Laptop profile.
* **`iso`**: Live USB recovery installation medium equipped with Calamares graphical installer, Plasma 6, Neovim, Tmux, Git, and network tools.

---

## System & Host Abstraction (`hosts/NixHome/default.nix`)

Hosts declare their hardware parameters, storage layout, network configurations, and feature toggles using custom module flags under the `sys` namespace.

### Host Profile Analysis: `NixHome`
* **Hardware Profile Imports**:
  * Intel CPU microcode & thermal drivers (`nixos-hardware/common/cpu/intel`)
  * AMD GPU driver stack & RADV Vulkan runtime (`nixos-hardware/common/gpu/amd`)
  * SSD optimizations (`nixos-hardware/common/pc/ssd`)
* **Declarative Feature Flags (`sys`)**:
  * **Desktop Environment**: Niri Wayland window manager (`sys.desktop.niri.enable = true`). Plasma & GNOME disabled.
  * **Workloads & Engines**:
    * `sys.gaming.enable = true` (Steam, Proton, Lutris, GameMode)
    * `sys.virtualisation.enable = true` (Libvirt/KVM, Docker, Kapsule)
    * `sys.development.enable = true` (Toolchains, Neovim, compilers)
    * `sys.apps.enable = true` & `sys.office.enable = true`
  * **Background & Hardware Services (`sys.services`)**:
    * Tailscale mesh networking (`tailscale.enable = true`)
    * Local AI inference stack (`ollama.enable = true`)
    * OpenRGB hardware control (`rgb.enable = true`)
    * Firmware management (`fwupd.enable = true`)
    * Remote access protocols (`remote.enable = true`)

---

## Module Wiring & Functional Distribution

### System Modules (`modules/system/`)

The system layer sets up core platform primitives and exposes high-level declarative `sys.*` feature flags:

* `default.nix`: Imports all system-level configurations.
* `core.nix`: Sets fundamental system settings.
* `apps.nix`: Configures core binaries and manages declarative Flatpak deployments via Flathub.
* `boot.nix`: Handles bootloader and the latest Linux kernel packages.
* `desktop.nix`: Desktop environment toggles and display servers.
* `env.nix`: Sets global environment variables.
* `fonts.nix`: Manages system-wide font installation.
* `gaming.nix`: Exposes `sys.gaming.enable` to configure Steam.
* `hardware.nix`: Configures hardware peripherals and daemons.
* `packages.nix`: Declares global CLI/GUI package suites and exposes top-level workstation feature flags.
* `services.nix`: Exposes background daemon options (`sys.services.*`).
* `users.nix`: Manages core user accounts, shell preferences, and group permissions.
* `virtualisation.nix`: Exposes `sys.virtualisation.enable` to activate Docker, KVM/Libvirt, and `virt-manager`.

### Home Manager Bridge (`modules/home-manager/`)
Integrates user-level configuration into the NixOS rebuild cycle using `home-manager.nixosModules.home-manager`. It forwards `specialArgs` (including `inputs` and `pkgs-stable`) into user modules and configures user state files under `users/rayu/`.

---

## User Space & Dotfile Architecture (`users/rayu/`)

The user configuration manages shell, editor, terminal, desktop compositors, and graphical tools under Home Manager.

### 1. Modular User Configuration
Here is the concise summary of your `users/rayu/` modules, matching the exact level of detail requested:

* `alacritty.nix`: Alacritty terminal settings and Catppuccin color scheme.
* `apps.nix`: Desktop GUI applications like browsers, media, and chat.
* `dev.nix`: Development toolchains, compilers, and IDE packages.
* `gaming.nix`: User-space game launchers and Proton utilities.
* `git.nix`: Git identity configuration and credential management.
* `hyprland.nix`: Hyprland configuration symlinks and per-host monitor rules.
* `mime.nix`: Default file associations and media viewers.
* `niri.nix`: Niri compositor config files and display output rules.
* `nvim.nix`: Neovim setup and Lua configuration symlinks.
* `office.nix`: Office tools and Mailspring email client wrapper.
* `packages.nix`: Miscellaneous base utilities and dynamic DE apps.
* `services.nix`: User-level background services like KDE Connect.
* `theme.nix`: GTK settings, dark mode, cursor, and icon themes.
* `zsh.nix`: Zsh shell configuration, Powerlevel10k theme, and custom aliases.

---

## Management & Deployment Workflow

### 1. System Rebuild Commands

#### Rebuild Local Host (Auto-detected via Hostname)
```bash
nrs # Alias for nixos-rebuild switch
```

#### Rebuild Specific Target Host
```bash
sudo nixos-rebuild switch --flake .#<hostname>
```

#### Dry Build / Test Configuration
```bash
nixos-rebuild dry-build --flake .#<hostname>
```

#### Garbage Collection & Store Optimization
```bash
# Delete older generations and collect garbage
nix-collect-garbage -d

# Optimize Nix store hardlinks
nix-store --optimise
```

### 2. Standalone Home Manager Deployment (CachyOS / Generic Linux)

#### Initial Switch on CachyOS
```bash
nix run github:nix-community/home-manager -- switch --flake .#rayu@cachyos
```

#### Subsequent Home Manager Rebuilds
```bash
home-manager switch --flake .#rayu@cachyos
```

### 3. Building Recovery / Installation ISO
```bash
nix build .#nixosConfigurations.iso.config.system.build.sdImageOrIso
```

---

## File Structure Reference Summary

| Location | Purpose | Key Responsibilities |
| --- | --- | --- |
| `flake.nix` | Flake Entrypoint | Flake inputs, channels, `specialArgs`, and host targets (`NixHome`, `NixPrecision`, `NixThinkpad`, `iso`). |
| `hosts/` | Host Profiles | Host hardware imports, storage mounts, network specs, and `sys.*` feature flags. |
| `modules/system/` | System Modules | System-level primitives, hardware drivers, desktop environments, daemons, and `sys.*` option declarations. |
| `modules/home-manager/` | HM Integration | Bridges Home Manager into NixOS rebuilds and forwards flake `inputs`/`pkgs-stable` down to user modules. |
| `users/rayu/` | User Configuration | User-space packages, terminal apps, desktop window manager configs, themes, and toolchains. |
| `users/rayu/dotfiles/` | Raw Dotfiles | Standalone `.kdl`, `.conf`, `.lua`, `.toml`, and `.zsh` configs linked directly via XDG paths. |

---
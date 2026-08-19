## What is "nix home-manager"?

Home-Manager is a tool built on the Nix package manager that allows you to declaratively manage your user environment across multiple Linux distributions (and macOS).


## Why home-manager is great for multi-distro developers

- **Declarative Configuration**: Define your entire development environment in a single file
- **Reproducibility**: The same setup works identically across Ubuntu, Fedora, Arch, or macOS (and if using Ubuntu, you can have more updated packages than it provides on your user environment;)
- **Atomic Updates**: Roll back failed configurations with a single command
- **Isolation**: Avoid conflicts between different package versions
- **No Root Required**: Install and manage packages without admin privileges


## Install nix instructions

NOTE: This is my personal nix user environment, tailored to my needs as a software developer. It was tested on Ubuntu 22.04 and 24.04.

1) Install nix:


``` bash

sh <(curl -L https://nixos.org/nix/install) --no-daemon


```

2) Add this to the end of your `.bashrc`:

``` bash

. ~/.nix-profile/etc/profile.d/nix.sh

```

3) Install home-manager:

``` bash

nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager

nix-channel --update

nix-shell '<home-manager>' -A install

```

4) Create symlink to your `home.nix` (the nix config entrypoint):

``` bash

mv ~/.config/home-manager/home.nix ~/.config/home-manager/home.nix.ORIG && \
    ln -s /storage/src/nix-home-manager/home.nix ~/.config/home-manager/home.nix

```


5) Test if the configuration works:

``` bash

home-manager build

```



6) Apply the configuration:

``` bash

home-manager switch

```


7) Get new versions of packages (must be run regularly):

``` bash

# Update the nixpkgs channel && test configuration && apply configuration:
nix-channel --update && home-manager build && home-manager switch

```

## Nix Home Manager — Generic Upgrade Guide (Channels-based)

### 1. Check your current channels

```bash
nix-channel --list
```

Note the current version in the URLs (e.g., `release-24.11`).

### 2. Find the latest stable release

Check https://endoflife.date/nixos for the current stable version and its
security support window. Pick the most recent release that still has active
support.

### 3. Update channels to the new version

Replace `NEW` with the target version (e.g., `25.11`):

```bash
nix-channel --add https://nixos.org/channels/nixos-NEW nixpkgs && \
nix-channel --add https://github.com/nix-community/home-manager/archive/release-NEW.tar.gz home-manager && \
nix-channel --update
```

> Both channels must match the same release number.

### 4. Build first — do not apply yet

```bash
home-manager build
```

Fix any errors or deprecation warnings before proceeding.

### 5. Apply the configuration

```bash
home-manager switch
```

### 6. Verify

```bash
home-manager --version && \
nix-channel --list
```

### 7. Rollback if something breaks

```bash
home-manager generations          # list available generations
home-manager switch --rollback    # revert to the previous generation
```

### Notes on `home.stateVersion`

- **Do NOT change `home.stateVersion` routinely.** It should remain at the
  value set when you first installed Home Manager.
- It controls stateful data migration behavior, not which packages are
  installed.
- Only bump it intentionally after reading the release notes at
  https://nix-community.github.io/home-manager/release-notes.xhtml

### Regular (non-major) package updates

No channel change needed — just run:

```bash
nix-channel --update && home-manager build && home-manager switch
```

> IMPORTANT: I have a cheatsheet [here](https://github.com/tiagoprn/devops/blob/master/cheats/nix.cheat) with those and other commands.

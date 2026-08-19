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

## Pinned package: lazygit

`lazygit` is pinned to a specific nixpkgs revision instead of following the
nixos-26.05 channel.

**Why:** the stable channel carries lazygit 0.61.1 and stable channels do not
receive feature-version bumps after their release cut, so newer lazygit
releases will not arrive there until the next stable release. To use the
newest lazygit (currently 0.64.1) without pulling every other package off the
stable channel, only lazygit is sourced from a pinned nixpkgs commit that
contains the 0.64.1 bump.

**How:** `packages_list.nix` defines `pinnedNixpkgs` with
`builtins.fetchTarball`, pointing at nixpkgs commit
`9c2bb5ac1738c8c53bf9989f32e332d3eac2d3e7` (lazygit 0.64.1, merged into
nixpkgs on 2026-08-12), and `home.packages` appends `pinnedNixpkgs.lazygit`.
Every other package still comes from the nixos-26.05 channel.

### Updating lazygit when a new release is available

1. Find the nixpkgs commit that bumps lazygit to the new version (look for a
   commit message like `lazygit: <old> -> <new>` touching
   `pkgs/by-name/la/lazygit/package.nix`):

   ```bash
   curl -s "https://api.github.com/repos/NixOS/nixpkgs/commits?path=pkgs/by-name/la/lazygit/package.nix&sha=master&per_page=10"
   ```

   or browse https://github.com/NixOS/nixpkgs/commits/master/pkgs/by-name/la/lazygit/package.nix.
   Copy the full commit SHA (40 hex characters).

2. Compute the hash of the unpacked tarball for that commit. The `--unpack`
   flag matters: `fetchTarball` validates the unpacked content, not the
   compressed archive:

   ```bash
   nix-prefetch-url --unpack https://github.com/NixOS/nixpkgs/archive/<FULL-SHA>.tar.gz
   ```

   This prints a base32 hash. Convert it to SRI form if you prefer (both
   forms are accepted by `fetchTarball`):

   ```bash
   nix --extra-experimental-features nix-command hash convert --hash-algo sha256 --to sri <BASE32-HASH>
   ```

3. Edit `packages_list.nix`: replace the commit SHA in the `url` and the
   `sha256` value inside the `pinnedNixpkgs` `fetchTarball` block.

4. Build and verify without switching:

   ```bash
   home-manager build
   ./result/home-path/bin/lazygit --version   # expect the new version
   ```

5. Apply and verify:

   ```bash
   home-manager switch
   lazygit --version
   ```

   If something breaks, roll back with `home-manager switch --rollback`.

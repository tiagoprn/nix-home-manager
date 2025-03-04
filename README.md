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

I have a cheatsheet [here](https://github.com/tiagoprn/devops/blob/master/cheats/nix.cheat) with those and other commands.

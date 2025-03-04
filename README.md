## Install nix instructions

1) Install nix: `sh <(curl -L https://nixos.org/nix/install) --no-daemon`

2) Add this to the end of your `.bashrc`: `. ~/.nix-profile/etc/profile.d/nix.sh`

3) Install home-manager:

``` bash

nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager

nix-channel --update

nix-shell '<home-manager>' -A install

```

4) Create symlink to your `home.nix` (the nix config entrypoint):

``` bash

$ mv ~/.config/home-manager/home.nix ~/.config/home-manager/home.nix.ORIG && \
    ln -s /storage/src/nix-home-manager/home.nix ~/.config/home-manager/home.nix

```


5) Test if the configuration works:

``` bash

$ home-manager build

```



6) Apply the configuration:

``` bash

$ home-manager switch

```


7) Get new versions of packages (must be run regularly):

``` bash

# Update the nixpkgs channel && test configuration && apply configuration:
$ nix-channel --update && home-manager build && home-manager switch

```

I have a cheatsheet [here](https://github.com/tiagoprn/devops/blob/master/cheats/nix.cheat) with those and other commands.

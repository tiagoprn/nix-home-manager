{ config, pkgs, ... }:

{
  # Import your package definitions
  imports = [ /storage/src/nix-home-manager/packages_list.nix ];

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;

  # Specify your home directory
  home.username = "tiago";
  home.homeDirectory = "/home/tiago";

  # Add these locale settings (ubuntu 22.04 as the host)
  home.language.base = "en_US.utf8";
  home.sessionVariables = {
    LANG = "en_US.utf8";
    LC_ALL = "en_US.utf8";
  };

  # State version
  home.stateVersion = "24.11";
}

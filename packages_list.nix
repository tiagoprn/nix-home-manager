{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    tmux
    tmuxp  # Python-based tmux session manager
  ];
}

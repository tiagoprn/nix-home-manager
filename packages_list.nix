{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    tmux
    tmuxp  # Python-based tmux session manager
    remind
    lua-language-server  # to use with neovim
    ripgrep
    lazygit
  ];
}

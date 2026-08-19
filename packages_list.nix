{ config, pkgs, lib, ... }:

let
  # lazygit pinned to nixpkgs commit 9c2bb5ac1738c8c53bf9989f32e332d3eac2d3e7
  # (lazygit 0.64.1, merged 2026-08-12). nixos-26.05 stable only carries 0.61.1,
  # so lazygit alone is sourced from this pinned revision.
  pinnedNixpkgs = import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/9c2bb5ac1738c8c53bf9989f32e332d3eac2d3e7.tar.gz";
    sha256 = "sha256-5boIObmatBXf386TiEVssnC0V4OdyHyS2IH6M+4FjhA=";
  }) { };
in
{
  home.packages = with pkgs; [
    tmux
    tmuxp  # Python-based tmux session manager
    remind
    lua-language-server  # to use with neovim
    ripgrep
    zk
  ] ++ [ pinnedNixpkgs.lazygit ];
}

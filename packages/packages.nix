{ pkgs, ... }:
{
  home.packages = with pkgs; [
    unzip
    zip
    nodePackages_latest.nodejs
    nodePackages_latest.pnpm
    nodePackages_latest.nodemon
    rustc
    rustup
    php
    cargo
    go
    clang
    gnumake
    llvmPackages_9.libclang
    sassc
    meson
    ninja
    cmake
    pkg-config
    gobject-introspection-unwrapped
    nmon
    glib
    jdk8
    jdk22
    gnupatch
    git
    curl
    wget
    xdg-desktop-portal-gtk
    libsecret
    gawk
    nettools
    coreutils
    gnome.gnome-keyring
    nix-prefetch
    cron
  ];
}

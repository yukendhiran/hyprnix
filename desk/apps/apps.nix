{ pkgs, config, ... }:
{
  home.packages = with pkgs; [
    brave
    vscode
    firefox
    ventoy
    firefoxpwa
    lunarvim
    ripgrep
    zed-editor
    firefox-devedition
    mysql84
    mysql-workbench
    obs-studio
    logseq
    aria2
    wezterm
    stacer
    codeium
    ventoy-full
    motrix
    floorp
    zram-generator
    iucode-tool
    htop
    fastfetch
    btop
    tmux
    preload
    vivaldi
    elisa
    gwenview
    okular
    oxygen
    libsForQt5.kdenlive
    krita
    libsForQt5.kdeconnect-kde
    onlyoffice-bin
    libsForQt5.kolourpaint
    libsForQt5.krdc
    vlc
    distrobox
    podman
    docker
    apx
    fnm
    bun
    kooha
    vim
    w3m
    neofetch
    neovim
    emacs
    openssl
    postman
    gparted
    anydesk
    libre
  ];

  nixpkgs.overlays = [
    ( final: prev: { b = final.brave; })
  ];

  programs = {
    brave.enable = true;
    browserpass.enable = true;
    browserpass.browsers = ["brave"];
    password-store = {
      enable = true;
      package = pkgs.pass.withExtensions ( exts: [exts.pass-otp ]);
      settings = {
        PASSWORD_STORE_DIR = "${config.xdg.dataHome}/password-store";
        PASSWORD_STORE_GPG_OPTS = "--no-throw-keyids";
        PASSWORD_STORE_ENABLE_EXTENSIONS = "true";
      };
    };
    #TODO: obs-studio = {
    #   enable = true;
    #   plugins = [
    #     pkgs.obs-studio-plugins.obs-gstreamer
    #     pkgs.obs-studio-plugins.obs-pipewire-audio-capture
    #     pkgs.obs-studio-plugins.obs-vkcapture
    #     pkgs.obs-studio-plugins.wlrobs
    #   ];
    # };
  };

}

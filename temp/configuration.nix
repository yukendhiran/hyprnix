{ config, pkgs, lib, ... }:

{

#=================IMPORTS===============================
  imports =
    [ #check -> https://github.com/NixOS/nixos-hardware
      #better hardware-support from nix-os
       <nixos-hardware/dell/latitude/3480>
       <home-manager/nixos> 
      ./hardware-configuration.nix
    ];
#================FILESYSTEM-SUPPORT=====================

  # NTFS Support
   boot.supportedFilesystems = [ "ntfs" ];

#==================BOOT=================================
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    # xanmod is a custom kernel
    kernelPackages = pkgs.linuxPackages_xanmod_latest;
    kernelParams = [ "intel_pstate=active" ];

    initrd.kernelModules = [ "i915" ];  
    kernelModules = [ "kvm-intel" ];
    
  };

#=====================ZRAM===================================
  #zram is a compression mechanism used to free up some RAM when its required
  #SWAP Partition is copying RAM Content to disk(SWAP) and ZRAM is compression happen within RAM
  #This is what i remember, sorry if wrong 
  zramSwap.enable = true;
  #zstd is algorithm used for compression
  zramSwap.algorithm = "zstd";

#=======================DRIVERS===========================
  # Video Drivers # I have intel fn
#  services.xserver.videoDrivers = [
#    "i915"
#    "intel"
#  ];

  hardware = {
    # Micro Code Updates
    cpu.intel.updateMicrocode = true;

    enableAllFirmware = true;
    #propriority driver
    enableRedistributableFirmware = true;
  };


  # Fwupd # Firmware updater 
  services.fwupd = {
    enable = true;
  };

#=======================================================

  # Dconf
#  programs.dconf.enable = true;
  
  # Dbus
#  services.dbus.enable = true;

#===================NETWORK=============================

  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
    firewall = rec {
      allowedTCPPortRanges = [
          { from = 1714; to = 1764; }
	];
      allowedUDPPortRanges = allowedTCPPortRanges;
      # allowedTCPPorts = [ ... ];
      # allowedUDPPorts = [ ... ];
      # enable = false;
    };
    # wireless.enable = true;
    # proxy = {
      # default = "http://user:password@proxy:port/";
      # noProxy = "127.0.0.1,localhost,internal.domain";
    # };
  }; 

#=======================TIME============================
  # Set your time zone.
  time.timeZone = "Asia/Kolkata";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_IN";

    i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IN";
    LC_IDENTIFICATION = "en_IN";
    LC_MEASUREMENT = "en_IN";
    LC_MONETARY = "en_IN";
    LC_NAME = "en_IN";
    LC_NUMERIC = "en_IN";
    LC_PAPER = "en_IN";
    LC_TELEPHONE = "en_IN";
    LC_TIME = "en_IN";
  };

#====================BLUETOOTH==============================

  hardware = {
    bluetooth ={
      enable = true;
      powerOnBoot = true;
    };
    
  };

  services.blueman.enable = true;

#  systemd.user.services.mpris-proxy = {
#    description = "Mpris proxy";
#    after = [ "network.target" "sound.target" ];
#    wantedBy = [ "default.target" ];
#    serviceConfig.ExecStart = "${pkgs.bluez}/bin/mpris-proxy";
#  };

#===================SERVICES============================
  services = { 
    xserver = {
      xkb.layout = "us";
      xkb.variant="";
      enable = true;
      videoDrivers = [
       "i915"
       "intel"
      ];
      displayManager = {
        # defaultSession = "gnome";
        gdm = {
          enable = true;
        };
      };
    };
    gvfs.enable = true;
    tumbler.enable = true;
    openssh = {
      enable = true;
      settings.X11Forwarding = true;
    };
    pipewire = {
      enable = true;
      pulse.enable = true;
      jack.enable = true;
      wireplumber.enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
    };
    flatpak.enable = true;
    dbus.packages = [ pkgs.gcr ];
    udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];
    gnome.gnome-keyring.enable = true;
    
    # Enable CUPS to print documents.
    printing.enable = true;
    # Touchpad Support
    libinput.enable = true;

  };
#=============VIDEO-ACCELERATION==========================
#  nixpkgs.config.packageOverrides = pkgs: {
#    intel-vaapi-driver = pkgs.intel-vaapi-driver.override { enableHybridCodec = true; };
#  };

  hardware.opengl = {
    driSupport = true; 
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      intel-vaapi-driver # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      libvdpau-va-gl
    ];
  };

  environment.sessionVariables = { LIBVA_DRIVER_NAME = "iHD"; };

#===============CPU-AND-POWER=============================

  # Better scheduling for CPU cycles - thanks System76!!!
  services.system76-scheduler.settings.cfsProfiles.enable = true;

  # Enable TLP (better than gnomes internal power manager)
  services.tlp = {
    enable = true;
    settings = {
      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 0;
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
    };
  };

  # Disable GNOMEs power management
  services.power-profiles-daemon.enable = false;

  # Enable powertop
  powerManagement.powertop.enable = true;

  # Enable thermald (only necessary if on Intel CPUs)
  services.thermald.enable = true;

#============USER=====================================
  
  users.users.yukendhiran = {
    isNormalUser = true;
    description = "yukendhiran";
    extraGroups = [ "networkmanager" "wheel" "libvirtd" ];
    packages = with pkgs; [];
    shell = pkgs.zsh;
  };

  # services Accounts
  services.accounts-daemon.enable = true;

#=================UNFREE================================

  nixpkgs = {
    config = {
     allowUnfree = lib.mkForce true;
     packageOverrides = pkgs: {
        intel-vaapi-driver = pkgs.intel-vaapi-driver.override { enableHybridCodec = true; };
     };
     permittedInsecurePackages = [ 
     	"electron-19.1.9"
	    "mailspring-1.11.0"
     ];
    };
    overlays = [
      (self: super: {
        fcitx-engines = pkgs.fctix5;
      })
    ];
  };

#================SYSTEM=================================

  nix = { 
    gc = {
      automatic = lib.mkDefault true;
      dates = lib.mkDefault "weekly";
      options = lib.mkDefault "--delete-older-than 2w";
    };
    settings = {
      auto-optimise-store = true;
      builders-use-substitutes = true;
      experimental-features = [ "nix-command" "flakes" ];
    };
  };
  
#================ALLOW-NON-NIX-BINARY======================

  #enable nixid for normal binary to work
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = [];
  # example to run codeium inside your vscode you need this, Codeium is open source github copilot alternative

#================FONTS======================================


  fonts.packages = with pkgs; [
     noto-fonts
     noto-fonts-cjk
     jetbrains-mono
     noto-fonts-emoji
     liberation_ttf
     fira-code
     fira-code-symbols
     mplus-outline-fonts.githubRelease
     dina-font
     proggyfonts
     wineWowPackages.fonts
     font-awesome
     nerdfonts
     nerd-font-patcher
     comic-relief
     google-fonts
  ];



#================PACKAGES===============================

  environment = {
    systemPackages = with pkgs; [
      home-manager
      git
      virt-manager
      virt-viewer
      mailspring
#===BuildTools======
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
#===Hypr====
    neofetch
    onefetch
    zathura
    rofi
    rofi-emoji
    bat
    jq
    xdg-desktop-portal-hyprland
    ffmpeg-full
    spicetify-cli
    wl-gammactl 
    wl-clipboard
    wf-recorder
    hyprpicker
    hyprshot
    lsd
    hdrop
    hyprnome 
    wayshot 
    imagemagick
    pavucontrol
    pamixer
    alsa-utils
    playerctl 
    brightnessctl
    socat
    xfce.thunar
    xfce.thunar-archive-plugin
    gnome.nautilus
    lxappearance
    mpv
    sassc
    supergfxctl
    hyprpicker
    slurp
    gnome.gnome-bluetooth
    wireplumber
    pipewire
    gsettings-desktop-schemas
    libnotify
    usbutils
    playerctl
    vulkan-tools
    glxinfo
    libva-utils
    networkmanager
    imagemagickBig
    swappy
    xdg-utils
    xdg-user-dirs
    qt6.qtwayland
    pulsemixer
    imv
    grimblast
    wlsunset
    cliphist
#===Desk====
    vscode
    firefox
    ventoy
   # firefoxpwa
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
    ];

    shells = with pkgs; [ bash zsh ];
    variables.EDITOR = "nvim";
   
  };

  programs = {
   adb.enable = true;
   ssh.startAgent = true;
   dconf.enable = true;
   zsh.enable = true;
   seahorse.enable = true;
   steam = {
     enable = true;
     remotePlay.openFirewall = true;
     dedicatedServer.openFirewall = true;
   };
   gnupg.agent = {
     enable = true;
     # enableSSHSupport = true;
   };
   hyprland = {
     enable = true;
     # package = inputs.hyprland.packages.${pkgs.system}.hyprland;
     xwayland.enable = true;
     # enableNvidiaPatches = true;
   };
  };

  # force the service to use wayland
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  sound.enable = true;
  hardware.pulseaudio.enable = false;

  security = {
    polkit.enable = true;
    rtkit.enable = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ 
      xdg-desktop-portal-gtk 
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-wlr
    ];
  };

#==================VIRTUALIZATION=======================
#
#  virtualisation = {
#    libvirtd = {
#      enable = true;
#      qemu.runAsRoot = true;
#        extraConfig = ''
#        unix_sock_group = "libvirtd"
#        unix_sock_rw_perms = "0770"
#      '';
#    };
#    virtualbox = {
#      host = {
#        enable= true;
#        enableExtensionPack = true;
#      };
#      guest = {
#        enable = true;
#	      x11 = true;
#      };
#    };
#  };
#=====================KERRING===========================
  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
       description = "polkit-gnome-authentication-agent-1";
       wantedBy = [ "graphical-session.target" ];
       wants = [ "graphical-session.target" ];
       after = [ "graphical-session.target" ];
       serviceConfig = {
         Type = "simple";
         ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
         Restart = "on-failure";
         RestartSec = 1;
         TimeoutStopSec = 10;
       };
    };

   user.services.mpris-proxy = {
      description = "Mpris proxy";
      after = [ "network.target" "sound.target" ];
      wantedBy = [ "default.target" ];
      serviceConfig.ExecStart = "${pkgs.bluez}/bin/mpris-proxy";
    };

    extraConfig = ''
      DefaultTimeoutStopSec=10s
    '';
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}

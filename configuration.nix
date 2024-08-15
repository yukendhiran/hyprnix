# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ 
      # hardware-support from nix-hardware
      <nixos-hardware/dell/latitude/3480>
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];


  # NTFS Support
   boot.supportedFilesystems = [ "ntfs" ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Which Kernel to use
  boot.kernelPackages = pkgs.linuxPackages_zen;
  
  boot.kernelParams = [
  "quiet"                                    # Reduce boot verbosity.
  "splash"                                   # Enable splash screen.
  "boot.shell_on_fail"                       # Debugging shell on boot failure.
  "cgroup_no_v1=all"                         # Use cgroup v2 for better resource management.
  "loglevel=2"                               # Reduce kernel log verbosity for faster boot.
  "rd.udev.log_level=2"                      # Reduce udev logging to minimize I/O load.
  "udev.log_priority=2"                      # Same as above, keeps logs minimal.
  "elevator=bfq"                             # Use BFQ scheduler for better HDD performance.
  "scsi_mod.use_blk_mq=1"                    # Enable multi-queue block layer for optimized I/O.
];



  boot.kernel.sysctl = {
  "vm.swappiness" = 20; # Moderate swapping to make use of your 16GB RAM while not overloading the HDD.
  "vm.vfs_cache_pressure" = 60; # Keep more filesystem metadata cached in RAM, improving HDD performance.
  "vm.dirty_ratio" = 40; # A slightly reduced dirty ratio to prevent large write bursts that can slow down your HDD.
  "vm.dirty_background_ratio" = 10; # Background writes start sooner, reducing chances of large write operations.
  "vm.max_map_count" = 262144; # Higher map count for better support of modern applications, but not excessively high.
  "kernel.task_delayacct" = 0; # Disable for less overhead, as detailed I/O accounting isn’t necessary for your use.
  "kernel.sched_latency_ns" = 6000000; # Increased latency to balance responsiveness with power efficiency.
  "kernel.sched_min_granularity_ns" = 1000000; # Adjusted for a smoother experience with a more balanced time slice.
  "kernel.sched_wakeup_granularity_ns" = 150000;
  # Balanced wakeup granularity to reduce latency without excessive context switching.
  "kernel.sched_migration_cost_ns" = 500000; 
  # Higher migration cost to reduce task migrations and potential CPU thrashing.
  "kernel.sched_cfs_bandwidth_slice_us" = 5000; # Increase bandwidth slice for better handling of burst workloads.
  "kernel.sysrq" = 1;                        # Enable SysRq for debugging and recovery.
};


  networking.hostName = "nixos"; # Define your hostname.
  networking.nameservers = [ "1.1.1.1" "8.8.8.8" ];  # Example for Cloudflare and Google DNS

  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

 # boot.initrd.kernelModules = [ "i915" ];
 # boot.kernelModules = [ "kvm-intel" ];
 # services.xserver.videoDrivers = [
 #   "i915"
 #   "intel"
 # ];

 services.xserver.videoDrivers = [ "intel" "modesetting" ];

 fileSystems."/".options = [ "noatime" ];


  # Enable CPU frequency scaling
  #powerManagement.cpuFreqGovernor = "performance";

  # Micro Code Updates
  hardware.cpu.intel.updateMicrocode = true;

  #intel driver
  nixpkgs.config.packageOverrides = pkgs: {
      intel-vaapi-driver = pkgs.intel-vaapi-driver.override { enableHybridCodec = true; };
    };

    hardware.opengl = {
    driSupport = true; 
    enable = true;
    extraPackages = with pkgs; [
        intel-media-driver
        intel-vaapi-driver
        vaapiVdpau
        libvdpau-va-gl
      ];

  };
  environment.sessionVariables = { LIBVA_DRIVER_NAME = "iHD"; };

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
  #services.power-profiles-daemon.enable = false;

  # Enable powertop
  powerManagement.powertop.enable = true;

  # Enable thermald (only necessary if on Intel CPUs)
  services.thermald.enable = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Dconf
  programs.dconf.enable = true;
  
  # Dbus
  services.dbus.enable = true;
  
  # Fwupd # Firmware updater  
  services.fwupd = {
    enable = true;
  };

  # Optimize NIX Store.
   nix.optimise = {
     automatic = true;
   };

  nix = {
    settings.auto-optimise-store = true;
    gc = {
      randomizedDelaySec = "10min";
      persistent = true;
      automatic =  true;
      dates = "weekly";
      options = "--delete-older-than 15d";
    };
    };

  # services Accounts
  services.accounts-daemon.enable = true;

  #enable nixid for normal binary to work
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = [];

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

  # flake
  nix.settings.experimental-features = ["nix-command" "flakes"];
 
   # flatpak support
  services.flatpak.enable = true;
  #Zram
  zramSwap.enable = true;
  zramSwap.algorithm = "zstd";

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  #services.xserver.enable = true;
 
  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  #services.desktopManager.plasma6.enable = true;

  # LightDm Display Manager
  #services.xserver.displayManager.lightdm.enable = true;
  #services.xserver.displayManager.lightdm.greeter = pkgs.lightdm-gtk-greeter;

  # Polkit
  security.polkit.enable = true;

  # Hyprland Config
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };


  hardware = {
    enableAllFirmware = true;
    #propriority driver
    enableRedistributableFirmware = true;
  };

  # Desktop Portals
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ 
    pkgs.xdg-desktop-portal-gtk 
    pkgs.xdg-desktop-portal-hyprland
    pkgs.xdg-desktop-portal-wlr
    ]; 

  programs.zsh = {
    enable = true;
    ohMyZsh.enable = true;
    ohMyZsh.theme = "mikeh";
    
    # Zsh Config.
    histSize = 10000;
    histFile = "$HOME/.zsh_history";

    # Plugins
    syntaxHighlighting.enable = true;
    autosuggestions.strategy = ["history" "completion" "match_prev_cmd"];
    autosuggestions.highlightStyle = "fg=cyan";
    syntaxHighlighting.highlighters = ["main" "brackets" "pattern" "cursor" "regexp" "root" "line"];
    autosuggestions.enable = true;
   
    # Build in oh-my-zsh plugins 
    ohMyZsh.plugins = ["sudo" ];
    
    # Alias
    shellAliases = {

      # LSD 
      ls = "lsd";
      ll = "lsd -l";
      cat = "bat";
      
      # Useful Nix OS commands
      edit = "sudo -E nvim /etc/nixos/configuration.nix";
      edit-unstable = "sudo -E nvim /etc/nixos/unstable.nix";
      update = "sudo nix-channel --update && sudo nixos-rebuild switch";

      # Trashy
      trash = "trash";
      list = "trash list";
      restore = "trash restore";
      restore-all = "trash restore --all";
      remove-all = "trash empty --all";

      # BashMount 
      bm = "bashmount"; 
    };
  };

  programs.starship = {
    enable = true;

    settings = {
      # right_format = "$cmd_duration";
      
      directory = {
        format = "[ ](bold #89b4fa)[ $path ]($style)";
        style = "bold #b4befe";
      };

      character = {
        success_symbol = "[ ](bold #89b4fa)[ ➜](bold green)";
        error_symbol = "[ ](bold #89b4fa)[ ➜](bold red)";
        # error_symbol = "[ ](bold #89dceb)[ ✗](bold red)";
      };

      cmd_duration = {
        format = "[󰔛 $duration]($style)";
        disabled = false;
        style = "bg:none fg:#f9e2af";
        show_notifications = false;
        min_time_to_notify = 60000;
      };        

     # palette = "catppuccin_mocha";
    }; # builtins.fromTOML (builtins.readFile "${inputs.catppuccin-starship}/palettes/mocha.toml");
  };

 



  # bluetooth
  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot
  services.blueman.enable = true;

  systemd.user.services.mpris-proxy = {
    description = "Mpris proxy";
    after = [ "network.target" "sound.target" ];
    wantedBy = [ "default.target" ];
    serviceConfig.ExecStart = "${pkgs.bluez}/bin/mpris-proxy";
  };

  # Configure keymap in X11
  services.xserver.xkb.variant = "";
  services.xserver.xkb.layout = "us";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.yukendhiran = {
    isNormalUser = true;
    description = "yukendhiran";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      kdePackages.kate
    #  thunderbird
    ];
    shell = pkgs.zsh;
  };

    


  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;


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
      fira-code
      nerdfonts
      nerd-font-patcher
      comic-relief
      google-fonts
  ];


  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    curl
    ventoy
    firefoxpwa
    lunarvim
    ripgrep
    zed-editor
    firefox-devedition
    mysql84
    mysql-workbench
    obs-studio
    mpv
    nodejs_20
    logseq
    aria2
    fish
    zsh
    wezterm
    
    stacer
    codeium
    ventoy-full
    motrix
    floorp
    rustup
    rustc
    go
    php
    zram-generator
    iucode-tool
    htop
    fastfetch
    btop
    tmux
    preload
    vivaldi
    vscode
    elisa
    gwenview
    jdk
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
    wget
    w3m
    neofetch
    neovim
    emacs
    git
    openssl
    postman
    # hyprland syspkg
    waybar
    dunst
    mako
    swww
    kitty
    wofi
    rofi-wayland
    wl-clipboard
    nm-tray
    networkmanager
    networkmanagerapplet
    imagemagickBig
    swappy
    wl-screenrec
    grim
    slurp
    libnotify
    wf-recorder
    eww
    ags
    hyprshot
    hdrop
    hyprnome
    lsd
    pamixer
    brightnessctl
    xfce.thunar
    cinnamon.nemo
    grimblast
    hyprpicker
    hypridle
    wlsunset 
    alsa-utils
    playerctl
    pavucontrol
    zsh-powerlevel10k
    wlroots
    ffmpeg-full
    libdvdcss
    mpv
    busybox
    bat
    unzip
    kdePackages.ark
    trashy
    swaybg
    xdg-user-dirs
    linux-firmware
    lxqt.lxqt-policykit 
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
   programs.mtr.enable = true;
   programs.gnupg.agent = {
     enable = true;
     enableSSHSupport = true;
   };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
    services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}

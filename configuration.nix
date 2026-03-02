# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      inputs.mangowc.nixosModules.mango
    ];

  # Bootloader.
  boot.loader.limine.enable = true;
  boot.loader.limine.style = {
    wallpapers = [./peakpx.jpg];
  };
  
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 1;
  security.polkit.enable = true;
  boot = {

    plymouth = {
      enable = true;
      theme = "blahaj";
      themePackages = [ pkgs.plymouth-blahaj-theme ];
    };

    # Enable "Silent boot"
    consoleLogLevel = 3;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "udev.log_level=3"
      "systemd.show_status=auto"
    ];
    # Hide the OS choice for bootloaders.
    # It's still possible to open the bootloader list by pressing any key
    # It will just not appear on screen unless a key is pressed

  };


  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "Arcanist"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/London";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  xdg.portal = {
    enable = true;
    #xdgOpenUsePortal = true;
    config = {
      common = {
        default = [
          "gtk"
        ];
      };
    };
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
  };

  # Enable Progams.
  services.displayManager.sddm = {
    enable = true;
    theme = "sddm-astronaut-theme";
    extraPackages = [(pkgs.sddm-astronaut.override {
      themeConfig = {
          background = "~/Pictures/Wallpapers/reim.png";
          backgroundMode = "fill";
      };
    })
    ];
  };
  
  services.desktopManager.plasma6.enable = true;
  services.jellyfin.enable = true;
  services.tailscale.enable = true;
  services.hardware.openrgb.enable = true;
  services.tailscale.useRoutingFeatures = "both";
  services.flatpak.enable = true;
  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    };

  services.mpd = {
  	enable = false;
	musicDirectory = "/home/ozgur/Music";
	dbFile = "/home/ozgur/.local/share/mpd/database";
	playlistDirectory = "/home/ozgur/.local/share/mpd/playlists";

	settings = {
	bind_to_address = "/home/ozgur/.config/mpd/socket";
	
	audio_output = [
	{
		type = "pulse";
		name = "pipewire";
		auto_update = "yes";
		restore_paused = "yes";
	}
  	];
	};
	};
	

  programs.niri.enable = true;
  programs.fish.enable = true;
  programs.steam = {
    enable = true;
    extraPackages = with pkgs; [ noto-fonts-cjk-sans noto-fonts-cjk-serif wqy_zenhei ];
  };
  programs.kdeconnect.enable = true;
  programs.mango.enable = true;

  # Enable the COSMIC login manager
  services.displayManager.cosmic-greeter.enable = false;

  # Enable the COSMIC desktop environment
  services.desktopManager.cosmic.enable = true;

  fileSystems."/mnt/SataSSD" = {
  	device = "/dev/disk/by-label/SataSSD";
	fsType = "ext4";
	options = [
		"nofail"
		"nosuid"
		"nodev"
		"x-gvfs-show"
		];
	};

  fileSystems."/mnt/NVME" = {
  	device = "/dev/disk/by-label/NVME";
	fsType = "btrfs";
	options = [
	  "compress=zstd:3"
		"nofail"
		"nosuid"
		"nodev"
		"x-gvfs-show"
		];
	};
  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "gb";
    variant = "";
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Configure console keymap
  console.keyMap = "uk";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ozgur = {
    shell = pkgs.fish;
    isNormalUser = true;
    description = "Ozgur Yigit";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      kdePackages.kate
    #  thunderbird
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    steam
    fastfetch
    niri
    kitty
    vesktop
    python314Packages.pip
    rmpc
    neovim
    protonplus
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
    git
    yazi
    sddm-astronaut
    kdePackages.qtmultimedia
    btop
    grim
    slurp
    wayfreeze
    wl-clipboard
    xwayland-satellite
    vicinae
    faugus-launcher
    mpd
    mpc
    gnome-disk-utility
    jellyfin
    jellyfin-web
    jellyfin-ffmpeg
    mpv
    cava
    mcomix
    quickshell
    pywal
    python314
    pywalfox-native
    rescrobbled
    mangohud
    obsidian
    qbittorrent
    openrgb
    wget
    unzip
    cargo
    home-manager
    helix
    mpd-mpris
    qt6Packages.qt6ct
    gamescope
    xdg-desktop-portal-gtk
    noisetorch
    plymouth-blahaj-theme

  ];
  
 
 fonts.packages = with pkgs; [
	jetbrains-mono
	noto-fonts
	noto-fonts-cjk-sans
  noto-fonts-cjk-serif
  noto-fonts-color-emoji
  liberation_ttf
  fira-code
  fira-code-symbols
  dina-font
  proggyfonts
  wqy_zenhei
  ];

  environment.variables = {
  	EDITOR = "nvim";
  	VISUAL = "nvim";
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

system.activationScripts.restartVicinae.text = ''
  pkill vicinae 2>/dev/null || true
'';
  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 8384 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

}

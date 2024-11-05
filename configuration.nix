# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./nvidia.nix
      ./keyboard.nix
      ./i3.nix
      ./asus.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = false;

  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/efi";
    };
    grub = {
      enable = true;
      efiSupport = true;
      devices = ["nodev"];
      useOSProber = true;
    };
  };

  networking.hostName = "zo"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  # Xbox controller
  hardware.xone.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  #i18n.defaultLocale = "en_US.UTF-8";
  #console = {
  #  font = "Lat2-Terminus16";
  #  keyMap = "us";
  #  useXkbConfig = true; # use xkb.options in tty.
  #};

  # Configure keymap in X11
  #services.xserver.xkb.layout = "us";
  #services.xserver.xkb.options = "eurosign:e,caps:escape";


  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.gnome.core-shell.enable = true;
  services.gnome.gnome-settings-daemon.enable = true;

  # Hyprland
  programs.hyprland.enable = true;

  # For app development
  programs.adb.enable = true;


  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  nixpkgs.config.allowUnfree = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.arthur = {
    shell = pkgs.zsh;
    isNormalUser = true;
    extraGroups = [ "plugdev" "adbusers" "kvm" "wheel" "networkmanager" "video" "docker" ]; # Enable ‘sudo’ for the user.
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  programs.steam.enable = true;
  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    pipewire

    # Softs
    git
    git-secret
    wget
    vim_configurable
    alacritty
    gammastep
    firefox
    chromium
    google-chrome
    htop
    zip
    unzip
    tree
    gimp
    tdesktop
    slack
    gparted
    blender
    libresprite
    cgoban
    qdirstat
    transmission
    ntfs3g
    xorg.xkbcomp
    pavucontrol
    openrgb-with-all-plugins
    openrgb

    nix-prefetch
    nix-prefetch-git
    direnv
    nix-direnv

    networkmanagerapplet

    # gtk
    gtk-engine-murrine
    gtk_engines
    gsettings-desktop-schemas
    lxappearance

    zsh
    oh-my-zsh

    android-studio

    # unfree
    (jetbrains.idea-ultimate.override { jdk = pkgs.jetbrains.jdk; })
    (jetbrains.clion.override { jdk = pkgs.jetbrains.jdk; })
    (jetbrains.pycharm-community.override { jdk = pkgs.jetbrains.jdk; })
    obs-studio
    discord
    handbrake
    parsec-bin
  ];

  services.udev.packages = [
    pkgs.android-udev-rules
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
  networking.firewall.enable = false;

  programs.vim.defaultEditor = true;

  # Enable zsh
  programs.zsh = {
    enable = true;
    shellAliases = {
      s = "git status";
      config = "vim ~/.config/sway/config";
      i3config = "vim ~/.config/i3/config";
      pconfig = "vim ~/.config/nixpkgs/config.nix";
      gconfig = "vim /etc/nixos/configuration.nix";
      sconfig = "vim /etc/nixos/my_sway.nix";
      i3exit = "~/.config/i3/i3exit";
      current = "source ~/Projects/current.sh";
    };
  };

  # Enable Oh-my-zsh
  programs.zsh.ohMyZsh = {
    enable = true;
    plugins = [ "git" "sudo" "docker" "kubectl" ];
    theme = "robbyrussell";
  }; 

  fonts.packages = with pkgs; [
    font-awesome
    cantarell-fonts
  ];

  # For nix direnv
	nix.extraOptions = ''
    keep-outputs = true
    keep-derivations = true
  '';

  environment.pathsToLink = [ "/share/nix-direnv" ];

	environment.interactiveShellInit = ''
		eval "$(direnv hook zsh)"
  '';

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  hardware.glasgow.enable = true;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "23.11"; # Did you read the comment?

}


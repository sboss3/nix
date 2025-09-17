
# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  boot.initrd.luks.devices."luks-6edd8b14-fa81-4e47-94e6-5683c3e359fc".device = "/dev/disk/by-uuid/6edd8b14-fa81-4e47-94e6-5683c3e359fc";
  # Setup keyfile
  boot.initrd.secrets = {
    "/boot/crypto_keyfile.bin" = null;
  };

  boot.loader.grub.enableCryptodisk = true;

  boot.initrd.luks.devices."luks-ab5baf5c-c837-4485-85f8-c58f99af398a".keyFile = "/boot/crypto_keyfile.bin";
  boot.initrd.luks.devices."luks-6edd8b14-fa81-4e47-94e6-5683c3e359fc".keyFile = "/boot/crypto_keyfile.bin";
  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Edmonton";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_CA.UTF-8";

  # Xorg
  services.xserver = {
    # Enable graphics
    enable = true;
   
    # Configure keymap in X11
    xkb = {
      layout = "us";
      variant = "";
    };

    # Load nvidia driver for Xorg and Wayland
    videoDrivers = ["nvidia"];

    # Qtile
    windowManager.qtile.enable = true;
  };

  # Enable OpenGL
  hardware.graphics = {
    enable = true;
  };

  hardware.nvidia = {
    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking up from sleep.
    # This fixes it by saving the entire VRAM memory to /tmp/ instead of just the bare essentials.
    powerManagement.enable = false;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Nvidia open source kernel module. Only supported by Turing or later.
    open = false;

    # Nvidia settings menu, via 'nvidia-settings'.
    nvidiaSettings = true;

    # Legacy driver for my Geforce GT 430
    package = config.boot.kernelPackages.nvidiaPackages.legacy_390;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.sgb = {
    isNormalUser = true;
    description = "Samuel Bosse";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  # Allow unfree packages
  nixpkgs.config = {
    allowUnfree = true;
    nvidia.acceptLicense = true;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    fastfetch
    btop
    git
    kitty
    helix
    firefox
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

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
  system.stateVersion = "25.05"; # Did you read the comment?

}

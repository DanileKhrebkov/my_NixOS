{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix   # сгенерируется при установке
  ];

  # --- Boot ---
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # AMD
  boot.kernelParams = [ "amd_pstate=active" ];
  hardware.cpu.amd.updateMicrocode = true;
  hardware.enableRedistributableFirmware = true;

  # --- Networking ---
  networking.hostName = "hogintosh";
  networking.networkmanager.enable = true;
  networking.firewall.enable = true;

  # --- Time & Locale ---
  time.timeZone = "Europe/Moscow";          # поменяй при необходимости
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_TIME = "ru_RU.UTF-8";
  };

  # --- Users ---
  users.users.hogintosh = {
    isNormalUser = true;
    description = "hogintosh";
    extraGroups = [ "networkmanager" "wheel" "docker" "video" "audio" "input" ];
    shell = pkgs.bash;
  };

  # Автологин без greeter → сразу в Sway
  services.getty.autologinUser = "hogintosh";

  # --- Sound ---
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # --- Power / Battery ---
  services.power-profiles-daemon.enable = true;
  # Альтернатива/дополнение: services.tlp.enable = true;

  # --- Docker ---
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
  };

  # --- Sway system-wide bits ---
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  # xdg portals (скриншоты, file dialogs и т.д.)
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # Polkit
  security.polkit.enable = true;

  # --- Packages (системные) ---
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    curl
  ];

  # Разрешаем unfree (нужно для некоторых вещей, VS Code и т.п.)
  nixpkgs.config.allowUnfree = true;

  # Flakes
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
  };

  # Garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  system.stateVersion = "24.11";   # поставь актуальный при установке
}
{ self, ... }: {
  flake.nixosModules.myMachineConfiguration = { config, pkgs, lib, ... }:
  let
    user = config.preferences.user.name;
    niri = lib.getExe self.packages.${pkgs.stdenv.hostPlatform.system}.myNiri;
  in {
    imports = [
      self.nixosModules.myMachineHardware
      self.nixosModules.locale
      self.nixosModules.environment
      self.nixosModules.pipewire
      self.nixosModules.chromium
      self.nixosModules.gimp
      self.nixosModules.gtk
      self.nixosModules.fish
      self.nixosModules.git
      self.nixosModules.niri
      self.nixosModules.alacritty
      self.nixosModules.fuzzel
      self.nixosModules.qutebrowser
      self.nixosModules.yazi
      self.nixosModules.neovim
      self.nixosModules.mpv
      self.nixosModules.tailscale
      self.nixosModules.samba
      self.nixosModules.ssh
      self.nixosModules.webapps
      self.nixosModules.gaming
      self.nixosModules.telegram
      self.nixosModules.vesktop
      self.nixosModules.fastfetch
    ];

    boot.loader.systemd-boot.enable      = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.kernelPackages                  = pkgs.linuxPackages_latest;

    preferences.user.name = "nixruuku";

    networking.hostName              = "FAGGOTTRON3000";
    networking.networkmanager.enable = true;

    services.greetd = {
      enable = true;
      settings = {
        default_session.command =
          "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd ${niri}";
        initial_session = {
          command = niri;
          inherit user;
        };
      };
    };

    security.polkit.enable = true;
    services.dbus.enable   = true;

    xdg.portal = {
      enable       = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      config.common.default = [ "gtk" ];
    };

    hardware.graphics.enable       = true;
    hardware.bluetooth.enable      = true;
    hardware.bluetooth.powerOnBoot = true;

    persistance.system.directories = [
      "/var/lib/bluetooth"
      "/var/lib/NetworkManager"
    ];

    users.users.${user} = {
      isNormalUser       = true;
      extraGroups        = [ "wheel" "networkmanager" "video" "audio" ];
      hashedPasswordFile = "/persistent/passwd";
    };

    nixpkgs.overlays = [
      (_: prev: { openldap = prev.openldap.overrideAttrs (_: { doCheck = false; }); })
    ];

    fonts.packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      ubuntu-sans cm_unicode corefonts unifont
      noto-fonts-cjk-sans
    ];
    fonts.fontconfig.defaultFonts = {
      serif     = [ "Ubuntu Sans" ];
      sansSerif = [ "Ubuntu Sans" ];
      monospace = [ "JetBrainsMono Nerd Font" ];
    };

    environment.systemPackages = with pkgs; [
      xwayland-satellite
      nautilus
      pavucontrol
    ];

    system.stateVersion = "24.11";
  };
}

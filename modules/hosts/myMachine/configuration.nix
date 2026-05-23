{ self, inputs, ... }: {
  flake.nixosModules.myMachineConfiguration = { pkgs, lib, ... }: {
    imports = [
      self.nixosModules.myMachineHardware
      self.nixosModules.locale
      self.nixosModules.gtk          # phase 6
      self.nixosModules.fish         # phase 7
      self.nixosModules.git          # phase 8
      self.nixosModules.niri
      self.nixosModules.alacritty
      self.nixosModules.fuzzel
      self.nixosModules.firefox
      self.nixosModules.yazi
      self.nixosModules.neovim
      self.nixosModules.mpv
      self.nixosModules.tailscale
      self.nixosModules.webapps
      self.nixosModules.gaming
      self.nixosModules.gamesStorage
    ];

    boot.loader.systemd-boot.enable    = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.kernelPackages = pkgs.linuxPackages_latest;

    networking.hostName = "FAGGOTTRON3000";
    networking.networkmanager.enable = true;

    services.greetd = {
      enable = true;
      settings = {
        default_session.command =
          "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd ${lib.getExe self.packages.${pkgs.stdenv.hostPlatform.system}.myNiri}";
        initial_session = {
          command = lib.getExe self.packages.${pkgs.stdenv.hostPlatform.system}.myNiri;
          user    = "nixruuku";
        };
      };
    };

    security.polkit.enable = true;
    security.rtkit.enable  = true;
    services.dbus.enable   = true;

    services.pipewire = {
      enable            = true;
      alsa.enable       = true;
      alsa.support32Bit = true;
      pulse.enable      = true;
    };

    xdg.portal = {
      enable       = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
      config.common.default = "gnome";
    };

    hardware.graphics.enable        = true;
    hardware.bluetooth.enable       = true;
    hardware.bluetooth.powerOnBoot  = true;

    services.openssh.enable = true;

    users.users.nixruuku = {
      isNormalUser = true;
      extraGroups  = [ "wheel" "networkmanager" "video" "audio" ];
      # shell is set by modules/features/fish.nix
    };

    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    nixpkgs.config.allowUnfree = true;
    nixpkgs.overlays = [
      (_: prev: {
        openldap = prev.openldap.overrideAttrs (_: { doCheck = false; });
      })
    ];

    fonts.packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      ubuntu-sans
      cm_unicode
      corefonts
      unifont
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
      nixd
      lua-language-server
    ];

    system.stateVersion = "24.11";
  };
}

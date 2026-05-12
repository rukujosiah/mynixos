{ self, inputs, ... }: {

  flake.nixosModules.myMachineConfiguration = { pkgs, lib, ... }: let
    myNiri = self.packages.${pkgs.stdenv.hostPlatform.system}.myNiri;
  in {
    imports = [
      self.nixosModules.myMachineHardware
      self.nixosModules.niri
    ];

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.kernelPackages = pkgs.linuxPackages_latest;

    networking.hostName = "FAGGOTTRON3000";
    networking.networkmanager.enable = true;

    # greetd autologins nixruuku and launches your wrapped niri directly.
    # initial_session runs once on first boot; subsequent boots show tuigreet
    # as a fallback in case niri crashes.
    services.greetd = {
      enable = true;
      settings = {
        default_session.command =
          "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --cmd ${lib.getExe myNiri}";
        initial_session = {
          command = lib.getExe myNiri;
          user = "nixruuku";
        };
      };
    };

    # Required for Wayland session startup, portals, and privilege escalation.
    security.polkit.enable = true;
    security.rtkit.enable = true;   # real-time scheduling for pipewire

    services.dbus.enable = true;

    # Pipewire replaces pulseaudio and provides JACK as well.
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    # XDG portals let apps open file choosers, share screens, etc.
    # xdg-desktop-portal-gnome works well with niri.
    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
      config.common.default = "gnome";
    };

    # GPU acceleration — required for niri.
    hardware.graphics.enable = true;

    # Bluetooth — noctalia has a bluetooth panel.
    hardware.bluetooth.enable = true;
    hardware.bluetooth.powerOnBoot = true;

    services.openssh.enable = true;

    users.users.nixruuku = {
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" "video" "audio" ];
    };

    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    environment.systemPackages = with pkgs; [
      alacritty
      firefox
      vim
      xwayland-satellite
    ];

    system.stateVersion = "24.11";
  };

}

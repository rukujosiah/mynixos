{ self, inputs, ... }: {
  flake.nixosModules.myMachineConfiguration = { pkgs, lib, ... }: let
    myNiri = self.packages.${pkgs.stdenv.hostPlatform.system}.myNiri;
  in {
    imports = [
      self.nixosModules.myMachineHardware
      self.nixosModules.locale
      self.nixosModules.niri
    ];

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.kernelPackages = pkgs.linuxPackages_latest;

    networking.hostName = "FAGGOTTRON3000";
    networking.networkmanager.enable = true;

    services.greetd = {
      enable = true;
      settings = {
        default_session.command =
          "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd ${lib.getExe myNiri}";
        initial_session = {
          command = lib.getExe myNiri;
          user = "nixruuku";
        };
      };
    };

    security.polkit.enable = true;
    security.rtkit.enable = true;
    services.dbus.enable = true;

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
      config.common.default = "gnome";
    };

    hardware.graphics.enable = true;
    hardware.bluetooth.enable = true;
    hardware.bluetooth.powerOnBoot = true;

    services.openssh.enable = true;

    users.users.nixruuku = {
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" "video" "audio" ];
    };

    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    environment.systemPackages = with pkgs; [
      xwayland-satellite
    ];

    system.stateVersion = "24.11";
  };
}

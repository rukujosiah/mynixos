{ ... }: {
  flake.nixosModules.gaming = { pkgs, lib, ... }: {
    hardware.graphics = {
      enable = lib.mkDefault = true;
      # enable32Bit = true;
    };

    programs = {
      gamemode.enable  = true;
      gamescope.enable = true;
      steam = {
        enable              = true;
        protontricks.enable = true;
      };
    };

    environment.systemPackages = with pkgs; [
      lutris
      mangohud
      # wineWow64Packages.staging
      # winetricks
    ];

    nix.settings = {
      extra-substituters        = [ "https://nix-gaming.cachix.org" ];
      extra-trusted-public-keys = [
        "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      ];
    };

    persistance.cache.directories = [
      ".local/share/Steam"
      ".config/lutris"
      ".local/share/lutris"
    ];
  };
}

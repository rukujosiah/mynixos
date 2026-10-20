{
  flake.nixosModules.gaming = { pkgs, lib, ... }: {
    hardware.graphics = {
      enable = lib.mkDefault true;
    };

    programs = {
      gamemode.enable  = true;
      gamescope.enable = true;
      steam = {
        enable              = true;
        protontricks.enable = true;
        extraCompatPackages = with pkgs; [ dwproton-bin ];
      };
    };

    environment.systemPackages = with pkgs; [
      lutris
      mangohud
    ];

    nix.settings = {
      extra-substituters        = [ "https://nix-gaming.cachix.org" ];
      extra-trusted-public-keys = [
        "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      ];
    };

    # custom proton builds like dwproton go in ~/.local/share/Steam/compatibilitytools.d
    persistance.cache.directories = [
      ".local/share/Steam"
      ".config/lutris"
      ".local/share/lutris"
    ];
  };
}

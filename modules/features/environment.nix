{ ... }: {
  flake.nixosModules.environment = { pkgs, ... }: {
    nix.settings.experimental-features = [ "nix-command" "flakes" ];
    nixpkgs.config.allowUnfree = true;
    programs.nix-ld.enable     = true;

    environment.systemPackages = with pkgs; [
      nix-inspect
    ];
  };
}

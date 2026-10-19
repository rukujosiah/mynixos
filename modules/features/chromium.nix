{ ... }: {
  flake.nixosModules.chromium = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.ungoogled-chromium ];

    # persistance.cache.directories = [ ".config/chromium" ];
  };
}

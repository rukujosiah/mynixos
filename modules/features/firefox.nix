{ ... }: {
  flake.nixosModules.firefox = { ... }: {
    programs.firefox = {
      enable = true;
      policies = {
        DisableTelemetry       = true;
        DisableFirefoxStudies  = true;
      };
    };

    # persistance.data.directories  = [ ".mozilla" ];
    # persistance.cache.directories = [ ".cache/mozilla" ];
  };
}

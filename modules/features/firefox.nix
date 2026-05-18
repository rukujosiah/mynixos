{ ... }: {
  flake.nixosModules.firefox = { ... }: {
    programs.firefox = {
      enable = true;
      policies = {
        DisableTelemetry       = true;
        DisableFirefoxStudies  = true;
        ExtensionSettings = {
          "uBlock0@raymondhill.net" = {
            installation_mode = "force_installed";
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          };
          "addon@darkreader.org" = {
            installation_mode = "force_installed";
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi";
          };
          # Unhook: install manually from addons.mozilla.org/en-US/firefox/addon/unhook-youtube/
          # then get its ID from about:debugging#/runtime/this-firefox and add it here.
        };
      };
    };
  };
}

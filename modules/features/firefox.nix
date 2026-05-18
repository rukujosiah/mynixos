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
          "myallychou@gmail.com" = {
	    installation_mode = "force_installed";
	    install_url = "https://addons.mozilla.org/firefox/downloads/latest/unhook-youtube/latest.xpi";
	  };
        };
      };
    };
  };
}

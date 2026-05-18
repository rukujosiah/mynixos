{ self, inputs, ... }: {
  flake.nixosModules.yazi = { pkgs, ... }: {
    environment.systemPackages = [
      self.packages.${pkgs.stdenv.hostPlatform.system}.myYazi
    ];
  };

  perSystem = { pkgs, ... }: {
    packages.myYazi = inputs.wrapper-modules.wrappers.yazi.wrap {
      inherit pkgs;
      settings.yazi = {
        mgr = {
          show_hidden    = false;
          sort_by        = "natural";
          sort_dir_first = true;
          sort_reverse   = false;
        };
        preview = {
          tab_size   = 2;
          max_width  = 600;
          max_height = 900;
        };
      };
    };
  };
}

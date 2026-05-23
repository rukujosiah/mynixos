{ self, inputs, ... }: {
  flake.nixosModules.git = { pkgs, lib, ... }: {
    environment.systemPackages = [
      self.packages.${pkgs.stdenv.hostPlatform.system}.myGit
      self.packages.${pkgs.stdenv.hostPlatform.system}.myNh
    ];
  };

  perSystem = { pkgs, lib, self', ... }: {
    packages.myGit = inputs.wrapper-modules.wrappers.git.wrap {
      inherit pkgs;
      settings.user = {
        name  = "Luke Josiah M. Nadal";
        email = "ruukuj@disroot.org";
      };
    };

    packages.myNh = inputs.wrapper-modules.wrappers.nh.wrap {
      inherit pkgs;
      flake = "$HOME/mynixos";
    };
  };
}

{ self, inputs, ... }: {
  flake.nixosModules.fuzzel = { pkgs, ... }: {
    environment.systemPackages = [
      self.packages.${pkgs.stdenv.hostPlatform.system}.myFuzzel
    ];
  };

  perSystem = { pkgs, ... }: {
    packages.myFuzzel = inputs.wrapper-modules.wrappers.fuzzel.wrap {
      inherit pkgs;
      settings = {
        main = {
          font             = "JetBrainsMono Nerd Font:size=12";
          lines            = 10;
          width            = 35;
          "horizontal-pad" = 12;
          "vertical-pad"   = 8;
          "inner-pad"      = 4;
          "border-width"   = 2;
          "border-radius"  = 6;
          "icons-enabled"  = true;
        };
        colors = {
          background       = "${self.themeNoHash.base00}f0";
          text             = "${self.themeNoHash.base07}ff";
          match            = "${self.themeNoHash.base09}ff";
          selection        = "${self.themeNoHash.base01}ff";
          "selection-text" = "${self.themeNoHash.base07}ff";
          "selection-match" = "${self.themeNoHash.base09}ff";
          border           = "${self.themeNoHash.base09}ff";
        };
      };
    };
  };
}

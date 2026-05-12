{ self, inputs, ... }: {
  flake.nixosModules.niri = { pkgs, lib, ... }: {
    # Enables PAM setup, environment variables, and the niri session entry.
    # We override the package with our wrapped version.
    programs.niri = {
      enable = true;
      package = self.packages.${pkgs.stdenv.hostPlatform.system}.myNiri;
    };
  };

  perSystem = { pkgs, lib, self', ... }: {
    packages.myNiri = inputs.wrapper-modules.wrappers.niri.wrap {
      inherit pkgs;
      settings = {
        spawn-at-startup = [
          (lib.getExe self'.packages.myNoctalia)
          # xwayland-satellite starts X11 compatibility layer;
          # niri will use this path when launching it
        ];

        xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;

        input.keyboard.xkb = {
          layout = "us,ua";
          options = "grp:alt_shift_toggle,caps:escape";
        };

        layout.gaps = 5;

        binds = {
          "Mod+Return".spawn = lib.getExe pkgs.alacritty;
          "Mod+Q".close-window = _: {};
          "Mod+S".spawn-sh =
            "${lib.getExe self'.packages.myNoctalia} ipc call launcher toggle";
          "XF86AudioRaiseVolume".spawn-sh =
            "wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%+";
          "XF86AudioLowerVolume".spawn-sh =
            "wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%-";
        };
      };
    };
  };
}

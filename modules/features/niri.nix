{ self, inputs, ... }: {
  flake.nixosModules.niri = { pkgs, lib, ... }: {
    programs.niri = {
      enable  = true;
      package = self.packages.${pkgs.stdenv.hostPlatform.system}.myNiri;
      useNautilus = false;
    };
  };

  perSystem = { pkgs, lib, self', ... }: {
    packages.myNiri = inputs.wrapper-modules.wrappers.niri.wrap {
      inherit pkgs;
      v2-settings = true;

      settings = {
        prefer-no-csd = true;

        input = {
          keyboard.xkb = {
            layout  = "us";
            options = "caps:escape";
          };
          mouse."accel-profile" = "flat";
        };

        layout = {
          gaps = 5;
          "focus-ring" = {
            width          = 2;
            "active-color" = self.theme.base09;
          };
        };

        window-rules = [
	  {
	    matches = [ { "app-id" = "org.gnome.Nautilus"; } ];
	    "open-floating" = true;
	  }
	  {
	    matches = [
	      { "app-id" = "pavucontrol"; }
	      { "app-id" = "org.pulseaudio.pavucontrol"; }
	    ];
	    "open-floating" = true;
	  }
	  {
	    matches = [ { "app-id" = "firefox"; title = "Picture-in-Picture"; } ];
	    "open-floating" = true;
	  }
	  {
	    matches = [ { "app-id" = "^Alacritty$"; } ];
	    # "geometry-corner-radius" = 8.0;
	    "background-effect"."blur" = true;
	  }
	];

	layer-rules = [
	  {
	    matches = [ { namespace = "^launcher$"; } ];   # fuzzel's default namespace
	    "background-effect"."blur" = true;
	  }
	];

        spawn-at-startup = [
	  (lib.getExe (pkgs.writeShellScriptBin "import-session-env" ''
            export XDG_CURRENT_DESKTOP=niri
            systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP DISPLAY
            ${pkgs.dbus}/bin/dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP DISPLAY
          ''))
          (lib.getExe self'.packages.myNoctalia)
          (lib.getExe (pkgs.writeShellScriptBin "wallpaper"
            ''${lib.getExe pkgs.swaybg} -c "${self.theme.base00}"''))
        ];

        "xwayland-satellite".path = lib.getExe pkgs.xwayland-satellite;

        binds = {
          # Launch
          "Mod+Return".spawn = lib.getExe self'.packages.myAlacritty;
          "Mod+D".spawn      = lib.getExe self'.packages.myFuzzel;
          "Mod+E".spawn-sh   = "${lib.getExe self'.packages.myAlacritty} -e ${lib.getExe self'.packages.myYazi}";
          "Mod+S".spawn-sh   = "${lib.getExe self'.packages.myNoctalia} ipc call launcher toggle";
          "Mod+Ctrl+V".spawn = lib.getExe pkgs.pavucontrol;

          # Window management
          "Mod+W".close-window            = _: {};
          "Mod+F".maximize-column         = _: {};
          "Mod+Shift+F".fullscreen-window = _: {};
          "Mod+O".toggle-overview         = _: {};
          "Mod+Ctrl+Q".spawn-sh           = "${pkgs.niri}/bin/niri msg action quit --skip-confirmation";

          # Focus
          "Mod+J".focus-window-down    = _: {};
          "Mod+K".focus-window-up      = _: {};
          "Mod+Up".focus-window-up     = _: {};
          "Mod+Down".focus-window-down = _: {};
          "Mod+Left".focus-column-left   = _: {};
          "Mod+Right".focus-column-right = _: {};

          # Move
          "Mod+Shift+Left".move-column-left   = _: {};
          "Mod+Shift+Right".move-column-right = _: {};
          "Mod+Shift+Up".move-window-up       = _: {};
          "Mod+Shift+Down".move-window-down   = _: {};

          # Resize
          "Mod+Ctrl+Left".set-column-width  = "-5%";
          "Mod+Ctrl+Right".set-column-width = "+5%";
          "Mod+Ctrl+Up".set-window-height   = "-5%";
          "Mod+Ctrl+Down".set-window-height = "+5%";

          # Workspaces — focus
          "Mod+1".focus-workspace = 1;
          "Mod+2".focus-workspace = 2;
          "Mod+3".focus-workspace = 3;
          "Mod+4".focus-workspace = 4;
          "Mod+5".focus-workspace = 5;
          "Mod+6".focus-workspace = 6;
          "Mod+7".focus-workspace = 7;
          "Mod+8".focus-workspace = 8;
          "Mod+9".focus-workspace = 9;

          # Workspaces — move
          "Mod+Shift+1".move-column-to-workspace = 1;
          "Mod+Shift+2".move-column-to-workspace = 2;
          "Mod+Shift+3".move-column-to-workspace = 3;
          "Mod+Shift+4".move-column-to-workspace = 4;
          "Mod+Shift+5".move-column-to-workspace = 5;
          "Mod+Shift+6".move-column-to-workspace = 6;
          "Mod+Shift+7".move-column-to-workspace = 7;
          "Mod+Shift+8".move-column-to-workspace = 8;
          "Mod+Shift+9".move-column-to-workspace = 9;

          # Workspaces — cycle
          "Mod+Tab".focus-workspace-down     = _: {};
          "Mod+Shift+Tab".focus-workspace-up = _: {};

          # Webapp launcher
          "Mod+Shift+D".spawn = lib.getExe self'.packages.myWebapps;

          # Screenshots
          "Print".spawn-sh =
            ''${lib.getExe pkgs.grim} -l 0 - | ${pkgs.wl-clipboard}/bin/wl-copy'';
          "Mod+Shift+S".spawn-sh =
            ''${lib.getExe pkgs.grim} -g "$(${lib.getExe pkgs.slurp} -w 0)" - | ${pkgs.wl-clipboard}/bin/wl-copy'';
          "Mod+Shift+E".spawn-sh =
            ''${pkgs.wl-clipboard}/bin/wl-paste | ${lib.getExe pkgs.swappy} -f -'';

          # Audio
          "XF86AudioRaiseVolume".spawn-sh = "wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%+";
          "XF86AudioLowerVolume".spawn-sh = "wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%-";
          "XF86AudioMute".spawn-sh        = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";

          # Brightness
          "XF86MonBrightnessUp".spawn-sh   = "${lib.getExe pkgs.brightnessctl} set 5%+";
          "XF86MonBrightnessDown".spawn-sh = "${lib.getExe pkgs.brightnessctl} set 5%-";
        };
      };
    };
  };
}

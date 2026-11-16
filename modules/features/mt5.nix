{ self, ... }: {
  flake.nixosModules.mt5 = { pkgs, ... }: {
    environment.systemPackages = [
      self.packages.${pkgs.stdenv.hostPlatform.system}.myMt5
    ];

    persistance.data.directories = [ ".local/share/mt5" ];
  };

  perSystem = { pkgs, lib, ... }: {
    packages.myMt5 =
    let
      launcher = pkgs.writeShellApplication {
        name          = "mt5";
        runtimeInputs = [ pkgs.wineWow64Packages.stable pkgs.findutils ];
        text = ''
          export WINEPREFIX="''${XDG_DATA_HOME:-$HOME/.local/share}/mt5"
          export WINEDEBUG=-all
          # mt5 needs neither mono nor gecko, skip their install prompts
          export WINEDLLOVERRIDES="mscoree,mshtml="

          setup="''${MT5_INSTALLER:-$HOME/Downloads/vtmarkets5setup.exe}"

          find_terminal() {
            find "$WINEPREFIX/drive_c" -maxdepth 3 -iname terminal64.exe -print -quit 2>/dev/null || true
          }

          # preservation pre-creates the (empty) prefix dir, so check for the registry instead
          if [ ! -f "$WINEPREFIX/system.reg" ]; then
            wineboot --init
          fi

          terminal="$(find_terminal)"

          if [ -z "$terminal" ]; then
            if [ ! -f "$setup" ]; then
              echo "mt5: not installed and no installer at $setup (set MT5_INSTALLER)" >&2
              exit 1
            fi
            # the installer offers to launch the terminal itself, so don't start a second one
            wine "$setup" || true
            exit 0
          fi

          cd "$(dirname "$terminal")"
          exec wine "$terminal" "$@"
        '';
      };
    in pkgs.symlinkJoin {
      name  = "mt5";
      paths = [
        launcher
        (pkgs.makeDesktopItem {
          name        = "mt5";
          desktopName = "MetaTrader 5";
          exec        = lib.getExe launcher;
          categories  = [ "Office" "Finance" ];
        })
      ];
      meta.mainProgram = "mt5";
    };
  };
}

{ self, ... }: {
  flake.nixosModules.capture = { pkgs, ... }:
    let system = pkgs.stdenv.hostPlatform.system;
    in {
      environment.systemPackages = [
        self.packages.${system}.myScreenshot
        self.packages.${system}.myScreenRecord
      ];
    };

  perSystem = { pkgs, ... }: {
    packages.myScreenshot = pkgs.writeShellApplication {
      name = "screenshot";
      runtimeInputs = with pkgs; [ grim slurp wl-clipboard coreutils ];
      text = ''
        set -euo pipefail
        dir="''${PICTURES_DIR:-$HOME/Pictures}"
        mkdir -p "$dir"
        region="$(slurp -d)" || exit 0
        [ -n "$region" ] || exit 0
        file="$dir/$(date +%Y%m%d-%H%M%S).png"
        grim -g "$region" - | tee "$file" | wl-copy --type image/png
      '';
    };

    packages.myScreenRecord = pkgs.writeShellApplication {
      name = "screenrecord";
      runtimeInputs = with pkgs; [ slurp wf-recorder coreutils ];
      text = ''
        set -euo pipefail
        dir="''${VIDEOS_DIR:-$HOME/Videos}"
        mkdir -p "$dir"
        pidfile="''${XDG_RUNTIME_DIR:-/tmp}/wf-recorder.pid"

        if [ -f "$pidfile" ] && kill -0 "$(cat "$pidfile")" 2>/dev/null; then
          pid="$(cat "$pidfile")"
          kill -INT "$pid"
          for _ in {1..30}; do
            kill -0 "$pid" 2>/dev/null || break
            sleep 0.1
          done
          rm -f "$pidfile"
          exit 0
        fi

        region="$(slurp -d)" || exit 0
        [ -n "$region" ] || exit 0

        file="$dir/$(date +%Y%m%d-%H%M%S).mp4"
        nohup wf-recorder -g "$region" -f "$file" >/dev/null 2>&1 &
        echo "$!" > "$pidfile"
      '';
    };
  };
}

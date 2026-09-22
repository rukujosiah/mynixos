{ self, ... }: {
  perSystem = { pkgs, ... }: let
    fastfetchCfg = pkgs.writeText "config.jsonc" (builtins.toJSON {
      "$schema" = "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json";
      display = {
        separator = " : ";
        color = {
          title     = "33";
          separator = "31";
          keys      = "34";
        };
      };
      modules = [
        "title" "separator"
        "os" "host" "kernel" "uptime"
        "packages" "shell"
        "display" "wm" "terminal"
        "cpu" "gpu" "memory"
      ];
    });
  in {
    packages.myFastfetch = pkgs.writeShellScriptBin "fastfetch" ''
      exec ${pkgs.fastfetch}/bin/fastfetch --config ${fastfetchCfg} "$@"
    '';
  };

  flake.nixosModules.fastfetch = { pkgs, ... }: {
    environment.systemPackages = [
      self.packages.${pkgs.stdenv.hostPlatform.system}.myFastfetch
    ];
  };
}

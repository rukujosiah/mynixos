{ self, inputs, ... }: {
  flake.nixosModules.webapps = { pkgs, lib, ... }: {
    environment.systemPackages = [
      self.packages.${pkgs.stdenv.hostPlatform.system}.myWebapps
    ];
  };

  perSystem = { pkgs, lib, self', ... }: {
    packages.myWebapps = inputs.wrapper-modules.wrappers.wlr-which-key.wrap {
      inherit pkgs;
      settings = {
        font          = "JetBrainsMono Nerd Font 12";
        background    = self.theme.base00;
        color         = self.theme.base06;
        border        = self.theme.base0F;
        separator     = " → ";
        border_width  = 2;
        corner_r      = 8;
        padding       = 15;
        anchor        = "bottom-right";
        margin_right  = 5;
        margin_bottom = 5;

        menu = [
          { key = "b"; desc = "Bluetooth";   cmd = "${lib.getExe self'.packages.myNoctalia} ipc call bluetooth togglePanel"; }
          { key = "c"; desc = "Claude";      cmd = "${lib.getExe pkgs.ungoogled-chromium} --app=https://claude.ai/login"; }
          { key = "y"; desc = "YouTube";     cmd = "${lib.getExe pkgs.ungoogled-chromium} --app=https://youtube.com"; }
          { key = "v"; desc = "VNDB";        cmd = "${lib.getExe pkgs.ungoogled-chromium} --app=https://vndb.org"; }
          { key = "j"; desc = "Jellyfin";    cmd = "${lib.getExe pkgs.ungoogled-chromium} --app=http://100.113.42.117:8096"; }
          { key = "k"; desc = "Kavita";      cmd = "${lib.getExe pkgs.ungoogled-chromium} --app=http://100.113.42.117:5000"; }
          { key = "q"; desc = "qBittorrent"; cmd = "${lib.getExe pkgs.ungoogled-chromium} --app=http://100.113.42.117:8081"; }
          { key = "s"; desc = "Shoko";       cmd = "${lib.getExe pkgs.ungoogled-chromium} --app=http://100.113.42.117:8111"; }
          { key = "p"; desc = "Pi-hole";     cmd = "${lib.getExe pkgs.ungoogled-chromium} --app=http://100.113.42.117:8080/admin"; }
          { key = "m"; desc = "TradingView"; cmd = "${lib.getExe pkgs.ungoogled-chromium} --app=https://tradingview.com"; }
          { key = "e"; desc = "Email";       cmd = "${lib.getExe pkgs.ungoogled-chromium} --app=https://webmail.disroot.org/?_task=login"; }
        ];
      };
    };
  };
}

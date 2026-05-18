{ self, inputs, lib, ... }: {
  flake.nixosModules.webapps = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      ungoogled-chromium
      self.packages.${pkgs.stdenv.hostPlatform.system}.myWebapps
    ];
  };

  perSystem = { pkgs, ... }: {
    packages.myWebapps = inputs.wrapper-modules.wrappers.wlr-which-key.wrap {
      inherit pkgs;
      settings = {
        font            = "JetBrainsMono Nerd Font 12";
        background      = self.theme.base00;
        color           = self.theme.base06;
        border          = self.theme.base09;
        separator       = " ➜ ";
        border_width    = 2;
        corner_r        = 15;
        padding         = 15;
        rows_per_column = 5;
        column_padding  = 25;
        anchor          = "bottom-right";
        margin_right    = 10;
        margin_bottom   = 10;
        margin_left     = 10;
        margin_top      = 0;
        menu = [
          {
            key  = "y";
            desc = "YouTube";
            cmd  = "${lib.getExe pkgs.ungoogled-chromium} --app=https://youtube.com";
          }
          {
            key  = "j";
            desc = "Jellyfin";
            cmd  = "${lib.getExe pkgs.ungoogled-chromium} --app=http://100.113.42.117:8096";
          }
	  {
	    key  = "k";
	    desc = "Kavita";
	    cmd  = "${lib.getExe pkgs.ungoogled-chromium} --app=http://100.113.42.117:5000";
	  }
	  {
	    key  = "q";
	    desc = "qBittorrent";
	    cmd  = "${lib.getExe pkgs.ungoogled-chromium} --app=http://100.113.42.117:8081";
	  }
	  {
	    key  = "s";
	    desc = "Shoko";
	    cmd  = "${lib.getExe pkgs.ungoogled-chromium} --app=http://100.113.42.117:8111";
	  }
	  {
	    key  = "p";
	    desc = "Pi-hole";
	    cmd  = "${lib.getExe pkgs.ungoogled-chromium} --app=http://100.113.42.117:8080/admin";
	  }
          {
            key  = "f";
            desc = "Firefox";
            cmd  = lib.getExe pkgs.firefox;
          }
        ];
      };
    };
  };
}

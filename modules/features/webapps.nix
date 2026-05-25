{ self, inputs, ... }: {
  flake.nixosModules.webapps = { pkgs, lib, ... }: {
    environment.systemPackages = [
      pkgs.ungoogled-chromium
      self.packages.${pkgs.stdenv.hostPlatform.system}.myWebapps
    ];
  };

  perSystem = { pkgs, lib, self', ... }: {
    packages.myWebapps = inputs.wrapper-modules.wrappers.wlr-which-key.wrap {
      inherit pkgs;
      settings = {
        font         = "JetBrainsMono Nerd Font 12";
        background   = self.theme.base00;
        color        = self.theme.base06;
        border       = self.theme.base0F;
        separator    = " → ";
        border_width = 2;
        corner_r     = 8;
        padding      = 15;
        anchor        = "bottom-right";
        margin_right  = 5;
        margin_bottom = 5;

        menu = [
          { key = "b"; desc = "Bluetooth"; cmd = "${lib.getExe self'.packages.myNoctalia} ipc call bluetooth togglePanel"; }
          { key = "w"; desc = "Wifi";      cmd = "${lib.getExe self'.packages.myNoctalia} ipc call wifi togglePanel"; }
          { key = "y"; desc = "YouTube";   cmd = "${lib.getExe pkgs.ungoogled-chromium} --app=https://youtube.com"; }
	  { key = "d"; desc = "Discord";   cmd = "${lib.getExe pkgs.ungoogled-chromium} --app=https://discord.com/login"; }
          { key = "j"; desc = "Jellyfin";  cmd = "${lib.getExe pkgs.ungoogled-chromium} --app=http://100.113.42.117:8096"; }
          { key = "k"; desc = "Kavita";    cmd = "${lib.getExe pkgs.ungoogled-chromium} --app=http://100.113.42.117:5000"; }
	  { key = "q"; desc = "qBit";      cmd = "${lib.getExe pkgs.ungoogled-chromium} --app=http://100.113.42.117:8081"; }
	  { key = "s"; desc = "Shoko";     cmd = "${lib.getExe pkgs.ungoogled-chromium} --app=http://100.113.42.117:8111"; }
	  { key = "p"; desc = "Pi-hole";   cmd = "${lib.getExe pkgs.ungoogled-chromium} --app=http://100.113.42.117:8080/admin"; }
        ];
      };
    };
  };
}

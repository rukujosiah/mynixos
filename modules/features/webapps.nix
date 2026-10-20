{ self, inputs, ... }: {
  flake.nixosModules.webapps = { pkgs, ... }: {
    environment.systemPackages = [
      self.packages.${pkgs.stdenv.hostPlatform.system}.myWebapps
    ];
  };

  perSystem = { pkgs, lib, self', ... }:
  let
    chromium = lib.getExe pkgs.ungoogled-chromium;
    noctalia = lib.getExe self'.packages.myNoctalia;
    home     = "http://100.113.42.117";

    app    = url: "${chromium} --app=${url}";
    webapp = key: desc: url: { inherit key desc; cmd = app url; };
  in {
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
          (webapp "h" "ChatGPT"     "https://chatgpt.com")
          (webapp "a" "Claude"      "https://claude.ai/login")
          (webapp "e" "Email"       "https://webmail.disroot.org/?_task=login")
          (webapp "g" "Gemini"      "https://gemini.google.com/app")
          (webapp "d" "JD-2"        "${home}:5800")
          (webapp "j" "Jellyfin"    "${home}:8096")
          (webapp "k" "Kavita"      "${home}:5000")
          (webapp "p" "Pi-hole"     "${home}:8080/admin")
          (webapp "s" "Shoko"       "${home}:8111")
          (webapp "q" "qBittorrent" "${home}:8081")
          { key = "b"; desc = "Bluetooth"; cmd = "${noctalia} ipc call bluetooth togglePanel"; }
        ];
      };
    };
  };
}

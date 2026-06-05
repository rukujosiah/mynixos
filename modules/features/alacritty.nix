{ self, inputs, ... }: {
  flake.nixosModules.alacritty = { pkgs, ... }: {
    environment.systemPackages = [
      self.packages.${pkgs.stdenv.hostPlatform.system}.myAlacritty
    ];
  };

  perSystem = { pkgs, lib, self', ... }: {
    packages.myAlacritty = inputs.wrapper-modules.wrappers.alacritty.wrap {
      inherit pkgs;
      settings = {
        env.TERM = "xterm-256color";
        terminal.shell.program = lib.getExe self'.packages.myFish;
        window = {
          opacity     = 0.95;
          decorations = "None";
          padding     = { x = 8; y = 8; };
        };
        scrolling.history = 10000;
        font = {
          normal = { family = "JetBrainsMono Nerd Font"; style = "Regular"; };
          bold   = { family = "JetBrainsMono Nerd Font"; style = "Bold"; };
          italic = { family = "JetBrainsMono Nerd Font"; style = "Italic"; };
          size   = 13.0;
        };
        colors = {
          primary    = { background = self.theme.base00; foreground = self.theme.base06; };
          cursor     = { text = self.theme.base00; cursor = self.theme.base07; };
          selection  = { text = self.theme.base00; background = self.theme.base04; };
          normal = {
            black = self.theme.base00; red     = self.theme.base08;
            green = self.theme.base0B; yellow  = self.theme.base0A;
            blue  = self.theme.base0D; magenta = self.theme.base0E;
            cyan  = self.theme.base0C; white   = self.theme.base06;
          };
          bright = {
            black = self.theme.base02; red     = self.theme.base08;
            green = self.theme.base0B; yellow  = self.theme.base0A;
            blue  = self.theme.base0D; magenta = self.theme.base0E;
            cyan  = self.theme.base0C; white   = self.theme.base07;
          };
        };
      };
    };
  };
}

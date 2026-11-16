{ lib, ... }: let
  # gruvbox dark, medium contrast (morhetz/gruvbox)
  theme = {
    base00 = "#282828"; # dark0
    base01 = "#3c3836"; # dark1
    base02 = "#504945"; # dark2
    base03 = "#665c54"; # dark3
    base04 = "#bdae93"; # light3
    base05 = "#d5c4a1"; # light2
    base06 = "#ebdbb2"; # light1
    base07 = "#fbf1c7"; # light0
    base08 = "#fb4934"; # bright red
    base09 = "#fe8019"; # bright orange
    base0A = "#fabd2f"; # bright yellow
    base0B = "#b8bb26"; # bright green
    base0C = "#8ec07c"; # bright aqua
    base0D = "#83a598"; # bright blue
    base0E = "#d3869b"; # bright purple
    base0F = "#d65d0e"; # neutral orange
  };
  themeNoHash = builtins.mapAttrs (_: lib.removePrefix "#") theme;
in {
  flake.theme       = theme;
  flake.themeNoHash = themeNoHash;
}

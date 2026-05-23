{ ... }: {
  flake.nixosModules.gtk = { pkgs, lib, ... }: let
    themeName    = "Gruvbox-Green-Dark-Medium";
    themePackage = pkgs.gruvbox-gtk-theme.override {
      colorVariants = [ "dark" ];
      sizeVariants  = [ "standard" ];
      themeVariants  = [ "green" ];
      tweakVariants  = [ "medium" "macos" ];
    };
    iconName    = "Gruvbox-Plus-Dark";
    iconPackage = pkgs.gruvbox-plus-icons;
    ini = ''
      [Settings]
      gtk-theme-name = ${themeName}
      gtk-icon-theme-name = ${iconName}
    '';
  in {
    environment.etc = {
      "xdg/gtk-3.0/settings.ini".text = ini;
      "xdg/gtk-4.0/settings.ini".text = ini;
    };
    environment.variables.GTK_THEME = themeName;
    programs.dconf = {
      enable = lib.mkDefault true;
      profiles.user.databases = [{
        lockAll = false;
        settings."org/gnome/desktop/interface" = {
          gtk-theme    = themeName;
          icon-theme   = iconName;
          color-scheme = "prefer-dark";
        };
      }];
    };
    environment.systemPackages = [ themePackage iconPackage pkgs.gtk3 pkgs.gtk4 ];
  };
}

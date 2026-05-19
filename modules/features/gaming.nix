{ ... }: {
  flake.nixosModules.gaming = { pkgs, ... }: {
    programs.steam = {
      enable                  = true;
      remotePlay.openFirewall = true;
    };

    programs.gamemode.enable = true;

    # 32-bit support required for Steam and Wine
    hardware.graphics.enable32Bit = true;

    environment.systemPackages = with pkgs; [
      # Launcher
      lutris

      # Wine — 32+64 bit staging build for VN compatibility
      wineWow64Packages.staging
      winetricks
      cabextract  # winetricks dependency for .cab packages

      # Monitoring
      mangohud
    ];

    # CJK fonts for Japanese VN rendering in Wine prefix
    fonts.packages = with pkgs; [
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
    ];
  };
}

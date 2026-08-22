{ ... }: {
  flake.nixosModules.chromium = { ... }: {
    programs.chromium.extensions = [
      { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm;https://clients2.google.com/service/update2/crx"; } # uBlock Origin
      { id = "khncfooichmfjbepaaaebmommgaepoid;https://clients2.google.com/service/update2/crx"; } # Unhook
    ];
  };
}

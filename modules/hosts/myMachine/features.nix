{ self, ... }: {
  flake.nixosModules.myMachineFeatures = {
    imports = with self.nixosModules; [
      locale
      environment
      pipewire

      gtk
      fish
      git
      niri
      capture
      alacritty
      fuzzel
      webapps

      chromium
      gimp
      qutebrowser
      yazi
      neovim
      mpv
      telegram
      vesktop
      fastfetch

      gaming
      mt5

      tailscale
      samba
      ssh
    ];
  };
}

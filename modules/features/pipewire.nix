{ ... }: {
  flake.nixosModules.pipewire = { ... }: {
    security.rtkit.enable = true;

    services.pipewire = {
      enable            = true;
      alsa.enable       = true;
      alsa.support32Bit = true;
      pulse.enable      = true;
    };

    persistance.cache.directories = [ ".local/state/wireplumber" ];
  };
}

{ ... }: {
  flake.nixosModules.tailscale = { ... }: {
    services.tailscale.enable = true;
    networking.firewall.trustedInterfaces = [ "tailscale0" ];

    preservation.preserveAt."/persistent".directories = [
      "/var/lib/tailscale"
    ];
  };
}

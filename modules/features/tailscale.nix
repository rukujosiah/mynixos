{
  flake.nixosModules.tailscale = {
    services.tailscale.enable = true;
    networking.firewall.trustedInterfaces = [ "tailscale0" ];

    persistance.system.directories = [
      "/var/lib/tailscale"   # so that it shuts up about `tailscale up` already
      "/var/cache/tailscale"
    ];
  };
}

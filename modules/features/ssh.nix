{
  flake.nixosModules.ssh = {
    services.openssh = {
      enable = true;
      settings.PermitRootLogin = "no";
    };
    networking.firewall.allowedTCPPorts = [ 22 ];

    persistance = {
      system.directories = [ "/etc/ssh" ];   # host keys
      data.directories   = [ ".ssh" ];
    };
  };
}

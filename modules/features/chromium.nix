{
  flake.nixosModules.chromium = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.ungoogled-chromium ];
    # no persistence on purpose (only used for stateless webapps)
  };
}

{
  flake.nixosModules.qutebrowser = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.qutebrowser ];

    # reminder to self that I configured this imperatively (config dir is real state and not a build output) 
    persistance = {
      data.directories  = [ ".config/qutebrowser" ];
      cache.directories = [ ".local/share/qutebrowser" ];
    };
  };
}

{ ... }: {
  flake.nixosModules.persistance = { lib, config, ... }: {
    options.persistance = {
      data.directories = lib.mkOption {
        type    = lib.types.listOf lib.types.str;
        default = [];
      };
      cache.directories = lib.mkOption {
        type    = lib.types.listOf lib.types.str;
        default = [];
      };
    };

    config.preservation.preserveAt."/persistent".users.nixruuku.directories =
      config.persistance.data.directories ++
      config.persistance.cache.directories;
  };
}

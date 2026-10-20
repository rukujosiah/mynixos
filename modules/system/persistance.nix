{
  flake.nixosModules.persistance = { config, lib, ... }:
  let
    cfg   = config.persistance;
    entry = lib.types.either lib.types.str lib.types.attrs;
    mkEntries = description: lib.mkOption {
      inherit description;
      type    = lib.types.listOf entry;
      default = [];
    };
  in {
    options.persistance = {
      data.directories = mkEntries
        "stuff like keys, repos, documents and wtvr irreplaceable user state shit";
      cache.directories = mkEntries
        "same volume as data for now (will split here if I'll ever add a dedicated subvolume)";
      system.directories = mkEntries "absolute system directories to keep";
      system.files       = mkEntries "absolute system files to keep";
    };

    config.preservation.preserveAt."/persistent" = {
      inherit (cfg.system) directories files;
      users.${config.preferences.user.name}.directories =
        cfg.data.directories ++ cfg.cache.directories;
    };
  };
}

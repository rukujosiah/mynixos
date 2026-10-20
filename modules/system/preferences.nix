{
  flake.nixosModules.preferences = { lib, ... }: {
    options.preferences.user.name = lib.mkOption {
      type        = lib.types.str;
      description = "other modules derive paths and ownership from this";
      example     = "lol";
    };
  };
}

{ self, inputs, lib, ... }: {
  flake.nixosModules.neovim = { pkgs, ... }: {
    environment.systemPackages = [
      self.packages.${pkgs.stdenv.hostPlatform.system}.myNeovim
    ];

    persistance.cache.directories = [ ".local/share/nvim" ];
  };

  perSystem = { pkgs, ... }: {
    packages.myNeovim = inputs.wrapper-modules.wrappers.neovim.wrap {
      inherit pkgs;
      settings = {
        config_directory = lib.generators.mkLuaInline "vim.fn.stdpath('config')";
        dont_link        = false;
      };
    };
  };
}

{ self, inputs, ... }: {
  flake.nixosModules.neovim = { pkgs, ... }: {
    environment.systemPackages = [
      self.packages.${pkgs.stdenv.hostPlatform.system}.myNeovim
    ];

    persistance.cache.directories = [ ".local/share/nvim" ];
  };

  perSystem = { pkgs, lib, ... }: {
    packages.myNeovim = inputs.wrapper-modules.wrappers.neovim.wrap {
      inherit pkgs;
      settings = {
        config_directory = lib.generators.mkLuaInline "vim.fn.stdpath('config')";
        dont_link        = false;
      };

      specs.theme = {
        data   = pkgs.vimPlugins.gruvbox-nvim;
        config = ''
          require("gruvbox").setup({ contrast = "", transparent_mode = true })
          vim.o.background = "dark"
          vim.cmd.colorscheme("gruvbox")
        '';
      };
    };
  };
}

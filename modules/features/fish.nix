{ self, inputs, ... }: {
  flake.nixosModules.fish = { pkgs, lib, ... }: {
    programs.fish.enable    = true;
    programs.direnv.enable  = true;
    programs.direnv.nix-direnv.enable = true;
    environment.shells      = [
      self.packages.${pkgs.stdenv.hostPlatform.system}.myEnvironment
    ];
    users.users.nixruuku.shell =
      self.packages.${pkgs.stdenv.hostPlatform.system}.myEnvironment;
  };

  perSystem = { pkgs, lib, self', ... }: {
    packages.myFish = inputs.wrapper-modules.wrappers.fish.wrap {
      inherit pkgs;
      shellAliases = {
        ls = "${pkgs.eza}/bin/eza --icons";
        ll = "${pkgs.eza}/bin/eza --icons -la";
      };
      configFile.content = ''
        set fish_greeting
        fish_vi_key_bindings

        function fish_prompt
          string join "" -- \
            (set_color red)     "[" \
            (set_color yellow)  $USER \
            (set_color green)   "@" \
            (set_color blue)    $hostname \
            (set_color magenta) " " (prompt_pwd) \
            (set_color red)     "]" \
            (set_color normal)  "$ "
        end

        ${pkgs.zoxide}/bin/zoxide init fish | source

        function yazi --wraps="yazi" --description="cd on exit"
          set tmp (command ${lib.getExe self'.packages.myYazi} --print-last-dir $argv)
          if test -n "$tmp"; cd "$tmp"; end
        end

        if type -q direnv
          direnv hook fish | source
        end
      '';
    };

    packages.myEnvironment = inputs.wrapper-modules.lib.wrapPackage {
      inherit pkgs;
      package       = self'.packages.myFish;
      extraPackages = with pkgs; [
        eza fd fzf zoxide dust ripgrep lazygit
        btop htop imagemagick imv ffmpeg-full yt-dlp
      ];
      env.EDITOR = lib.getExe self'.packages.myNeovim;
      passthru.shellPath = "/bin/fish";
    };
  };
}

{ self, inputs, ... }: {
  flake.nixosModules.fish = { pkgs, ... }: {
    programs.fish.enable = true;
    programs.direnv = {
      enable            = true;
      nix-direnv.enable = true;
    };
    environment.shells = [
      self.packages.${pkgs.stdenv.hostPlatform.system}.myFish
    ];
    users.users.nixruuku.shell =
      self.packages.${pkgs.stdenv.hostPlatform.system}.myFish;
  };

  perSystem = { pkgs, lib, self', ... }:
  let
    toolPkgs = with pkgs; [
      eza fd fzf zoxide dust ripgrep lazygit
      btop htop imagemagick imv ffmpeg-full yt-dlp
      nixd lua-language-server
    ];
  in {
    packages.myFish = inputs.wrapper-modules.wrappers.fish.wrap {
      inherit pkgs;
      shellAliases = {
        ls = "eza --icons";
        ll = "eza --icons -la";
      };
      configFile.content = ''
        set fish_greeting
        fish_vi_key_bindings

        set -gx PATH ${lib.concatMapStringsSep " " (p: "${p}/bin") toolPkgs} $PATH

        function fish_prompt
          string join "" -- \
            (set_color red)     "[" \
            (set_color yellow)  $USER \
            (set_color green)   "@" \
            (set_color blue)    $hostname \
            (set_color magenta) " " (prompt_pwd) \
            (set_color red)     "]" \
            (set_color normal)  '$ '
        end

        zoxide init fish | source

        function yazi --wraps="yazi" --description="cd on exit"
          set tmp (command ${lib.getExe self'.packages.myYazi} --print-last-dir $argv)
          if test -n "$tmp"; cd "$tmp"; end
        end

        if type -q direnv
          direnv hook fish | source
        end
      '';
    };
  };
}

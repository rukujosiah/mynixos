{ self, inputs, ... }: {
  flake.nixosModules.zsh = { config, pkgs, ... }:
  let
    myZsh = self.packages.${pkgs.stdenv.hostPlatform.system}.myZsh;
  in {
    programs.zsh.enable = true;
    programs.direnv = {
      enable            = true;
      nix-direnv.enable = true;
    };
    environment.shells = [ myZsh ];
    users.users.${config.preferences.user.name}.shell = myZsh;

    persistance.data.directories  = [ ".local/share/zsh" ];
    persistance.cache.directories = [
      ".local/share/direnv"
      ".local/share/zoxide"
      ".cache/zsh"
      ".cache/starship"
    ];
  };

  perSystem = { pkgs, lib, self', ... }:
  let
    toolPkgs = with pkgs; [
      eza fd fzf zoxide dust ripgrep lazygit
      htop imagemagick imv ffmpeg-full yt-dlp
      nixd lua-language-server
    ];
    starship = lib.getExe self'.packages.myStarship;
  in {
    packages.myStarship = inputs.wrapper-modules.wrappers.starship.wrap {
      inherit pkgs;
      settings = {
        add_newline = false;
        format = "$directory$git_branch$git_status$python$nodejs$rust$cmd_duration$line_break$character";

        directory = {
          style             = "bold white";
          truncation_length = 3;
          truncate_to_repo  = false;
          read_only         = " ";
        };

        git_branch = {
          symbol = "󰘬 ";
          style  = "bright-black";
          format = "[$symbol$branch]($style) ";
        };

        git_status = {
          style      = "bright-black";
          format     = "([$all_status$ahead_behind]($style) )";
          conflicted = "✘";
          ahead      = "⇡";
          behind     = "⇣";
          diverged   = "⇕";
          untracked  = "?";
          modified   = "!";
          staged     = "+";
          stashed    = "$";
        };

        python = {
          symbol = " ";
          style  = "bright-black";
          format = "[$symbol$version( \\($virtualenv\\)) ]($style)";
        };

        nodejs = {
          symbol = " ";
          style  = "bright-black";
          format = "[$symbol$version ]($style)";
        };

        rust = {
          symbol = " ";
          style  = "bright-black";
          format = "[$symbol$version ]($style)";
        };

        cmd_duration = {
          min_time          = 2000;
          show_milliseconds = false;
          format            = "[took $duration]($style) ";
          style             = "bright-black";
        };

        character = {
          success_symbol = "[❯](white)";
          error_symbol   = "[❯](bold white)";
          vimcmd_symbol  = "[❮](white)";
        };
      };
    };

    packages.myZsh = inputs.wrapper-modules.wrappers.zsh.wrap {
      inherit pkgs;
      skipGlobalRC = true;
      runtimePkgs  = toolPkgs;

      zshAliases = {
        ls = "eza --icons";
        ll = "eza -lah --icons --git";
        la = "eza -a --icons";
        lt = "eza --tree --icons";
      };

      zshrc.content = ''
        # Live autocompletion (must be sourced FIRST, before compinit)
        source ${pkgs.zsh-autocomplete}/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh

        zstyle ':autocomplete:*' min-input 1
        zstyle ':autocomplete:*' delay 0.05

        zmodload -i zsh/terminfo

        bindkey '^I' menu-complete
        bindkey "$terminfo[kcbt]" reverse-menu-complete
        bindkey '^[[A' up-line-or-history
        bindkey '^[[B' down-line-or-history

        # Prompt
        eval "$(${starship} init zsh)"

        # eza (monochrome)
        export EZA_COLORS="uu=bright-black:gu=bright-black:da=bright-black:ur=white:uw=bright-black:ux=white:ue=bright-black:gr=bright-black:gw=bright-black:gx=white:tr=bright-black:fi=white:di=bright-white:ln=bright-black:pi=bright-black:so=bright-black:bd=bright-black:cd=bright-black:or=bright-black:mi=bright-black:ex=white"

        # Completion styling
        zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
        zstyle ':completion:*' list-colors \
          '=(#b)*(=0)=38;5;250' \
          '=(#b)*(=1)=38;5;255' \
          '=(#b)*(=2)=38;5;245' \
          '=(#b)*(=3)=38;5;240'
        zstyle ':completion:*:descriptions' format '%F{8}-- %d --%f'

        # History
        HISTFILE="$HOME/.local/share/zsh/history"
        HISTSIZE=10000
        SAVEHIST=10000
        setopt APPEND_HISTORY SHARE_HISTORY HIST_IGNORE_DUPS HIST_IGNORE_SPACE HIST_REDUCE_BLANKS
        mkdir -p "''${HISTFILE:h}" "''${XDG_CACHE_HOME:-$HOME/.cache}/zsh"

        # Autosuggestions
        ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'
        source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh

        # Syntax highlighting (keep LAST)
        source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
        ZSH_HIGHLIGHT_STYLES[command]='fg=white'
        ZSH_HIGHLIGHT_STYLES[builtin]='fg=white'
        ZSH_HIGHLIGHT_STYLES[function]='fg=white'
        ZSH_HIGHLIGHT_STYLES[alias]='fg=white'
        ZSH_HIGHLIGHT_STYLES[path]='fg=245'
        ZSH_HIGHLIGHT_STYLES[comment]='fg=240'
        ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=245'

        # zoxide
        eval "$(zoxide init zsh)"

        # yazi: cd on exit
        function yazi() {
          local tmp
          tmp="$(command ${lib.getExe self'.packages.myYazi} --print-last-dir "$@")"
          if [[ -n "$tmp" ]]; then
            cd "$tmp"
          fi
        }

        # direnv
        if (( $+commands[direnv] )); then
          eval "$(direnv hook zsh)"
        fi
      '';
    };
  };
}

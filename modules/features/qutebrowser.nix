{ ... }: {
  flake.nixosModules.qutebrowser = { pkgs, ... }: {
    environment.systemPackages = [
      pkgs.qutebrowser
    ];
  };

  perSystem = { pkgs, ... }: let
    ytHideCss = pkgs.writeText "qb-yt-hide.css" ''
      /* Unhook equivalent — suppress YouTube feed, sidebar, end screen, Shorts */
      ytd-browse[page-subtype="home"] ytd-rich-grid-renderer,
      ytd-browse[page-subtype="home"] ytd-shelf-renderer,
      #related,
      ytd-rich-shelf-renderer[is-shorts],
      ytd-reel-shelf-renderer,
      .ytp-endscreen-content,
      ytd-watch-next-secondary-results-renderer { display: none !important; }
    '';

    configPy = pkgs.writeText "qb-config.py" ''
      config.load_autoconfig(False)

      # Ad blocking
      config.set('content.blocking.method', 'both')
      config.set('content.blocking.adblock.lists', [
          'https://easylist.to/easylist/easylist.txt',
          'https://easylist.to/easylist/easyprivacy.txt',
          'https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/filters.txt',
          'https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/privacy.txt',
          'https://raw.githubusercontent.com/uBlockOrigin/uAssets/master/filters/unbreak.txt',
      ])

      config.set('content.user_stylesheets', ['${ytHideCss}'],
                 'https://www.youtube.com/*')

      config.set('content.javascript.enabled', True)
      config.set('tabs.last_close', 'close')
      config.set('auto_save.session', False)
      config.set('content.cookies.accept', 'no-3rdparty')
    '';
  in {
    packages.myQutebrowser = pkgs.writeShellScriptBin "qutebrowser" ''
      exec ${pkgs.qutebrowser}/bin/qutebrowser --config-py ${configPy} "$@"
    '';
  };
}

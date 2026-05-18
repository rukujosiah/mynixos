{ self, inputs, ... }: {
  flake.nixosModules.mpv = { pkgs, ... }: {
    environment.systemPackages = [
      self.packages.${pkgs.stdenv.hostPlatform.system}.myMpv
    ];
  };

  perSystem = { pkgs, ... }: {
    packages.myMpv = inputs.wrapper-modules.wrappers.mpv.wrap {
      inherit pkgs;
      "mpv.conf".content = ''
        vo=gpu-next
        hwdec=auto
        profile=gpu-hq
        video-sync=display-resample
      '';
    };
  };
}

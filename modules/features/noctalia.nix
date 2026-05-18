{ self, inputs, ... }: {
  perSystem = { pkgs, ... }: {
    packages.myNoctalia = inputs.wrapper-modules.wrappers.noctalia-shell.wrap {
      inherit pkgs;

      colors = {
        mError            = self.theme.base08;
        mHover            = self.theme.base0D;
        mOnError          = self.theme.base00;
        mOnHover          = self.theme.base00;
        mOnPrimary        = self.theme.base00;
        mOnSecondary      = self.theme.base00;
        mOnSurface        = self.theme.base07;
        mOnSurfaceVariant = self.theme.base06;
        mOnTertiary       = self.theme.base00;
        mOutline          = self.theme.base02;
        mPrimary          = self.theme.base0B;
        mSecondary        = self.theme.base0A;
        mShadow           = self.theme.base00;
        mSurface          = self.theme.base00;
        mSurfaceVariant   = self.theme.base01;
        mTertiary         = self.theme.base0D;
      };

      settings = {
        settingsVersion = 32;

        bar = {
          position  = "left";
          exclusive = true;
          floating  = false;
          widgets = {
            left = [
              {
                id                    = "Workspace";
                hideUnoccupied        = true;
                followFocusedScreen   = false;
                characterCount        = 2;
                enableScrollWheel     = true;
              }
            ];
            center = [];
            right = [
              { id = "KeyboardLayout"; displayMode = "forceOpen"; }
              { id = "Volume";         displayMode = "alwaysHide"; }
              { id = "Microphone";     displayMode = "alwaysHide"; }
              {
                id             = "Tray";
                drawerEnabled  = true;
                hidePassive    = false;
              }
              {
                id               = "Clock";
                formatVertical   = "HH mm - dd MM";
                formatHorizontal = "HH:mm ddd, MMM dd";
                usePrimaryColor  = true;
              }
            ];
          };
        };

        general = {
          animationSpeed     = 1;
          lockOnSuspend      = true;
          enableShadows      = true;
          dimmerOpacity      = 0.15;
        };

        notifications = {
          enabled                  = true;
          location                 = "top_right";
          normalUrgencyDuration    = 8;
          criticalUrgencyDuration  = 15;
          overlayLayer             = true;
        };

        osd = {
          enabled      = true;
          location     = "bottom";
          overlayLayer = true;
        };

        network.wifiEnabled = true;
      };
    };
  };
}

{ self, inputs, ... }: {
  perSystem = { pkgs, ... }: {
    packages.myNoctalia = inputs.wrapper-modules.wrappers.noctalia-shell.wrap {
      inherit pkgs;
      settings = {
        settingsVersion = 32;

        bar = {
          position = "left";
          exclusive = true;
          floating = false;
          widgets = {
            left = [
              {
                id = "Workspace";
                hideUnoccupied = true;
                followFocusedScreen = false;
                characterCount = 2;
              }
            ];
            center = [];
            right = [
              { id = "KeyboardLayout"; displayMode = "forceOpen"; }
              { id = "Volume"; displayMode = "alwaysHide"; }
              { id = "Tray"; drawerEnabled = true; hidePassive = false; }
              {
                id = "Clock";
                formatVertical = "HH mm - dd MM";
                formatHorizontal = "HH:mm ddd, MMM dd";
              }
            ];
          };
        };

        general = {
          animationSpeed = 1;
          lockOnSuspend = true;
          enableShadows = true;
          dimmerOpacity = 0.15;
        };

        notifications = {
          enabled = true;
          location = "top_right";
          normalUrgencyDuration = 8;
          criticalUrgencyDuration = 15;
        };

        osd = {
          enabled = true;
          location = "bottom";
          overlayLayer = true;
        };

        network = { wifiEnabled = true; };
      };
    };
  };
}

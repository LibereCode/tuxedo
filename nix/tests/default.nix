{
  inputs,
  self,
  ...
}:
{
  perSystem =
    {
      pkgs,
      ...
    }:
    {
      checks.tuxedo = pkgs.testers.runNixOSTest {
        name = "Tuxedo HM modules test";
        nodes = {
          machine1 =
            {
              ...
            }:
            {
              imports = [
                inputs.home-manager.nixosModules.default
              ];

              boot.loader = {
                systemd-boot.enable = true;
                efi.canTouchEfiVariables = true;
              };

              users.users.whitetie = {
                isNormalUser = true;
                extraGroups = [ "wheel" ];
                uid = 1000;
              };

              home-manager.users.whitetie = {
                imports = [
                  self.homeModules.tuxedo
                ];

                home = {
                  username = "whitetie";
                  stateVersion = "26.05";
                };

                programs.tuxedo = {
                  enable = true;
                  # package = ;

                  settings = {
                  };

                  keybinds = {
                    normal = {
                      begin_edit_insert = [
                        "i"
                        "a"
                      ];
                      toggle_archive_view = "z";
                      archive_completed = "Z";
                    };
                  };

                  themes = {
                    kanagawa-dragon = {
                      name = "Kanagawa Dragon";
                      bg = "#181616";
                      panel = "#282727";
                      border = "#625e5a";
                      fg = "#c5c9c5";
                      dim = "#625e5a";
                      accent = "#658594";
                      cursor = "#393836";
                      selection = "#223249";
                      selected = "#223249";
                      statusbar = "#282727";
                      status_fg = "#DCD7BA";
                      mode_fg = "#223249";
                      mode_bg = "#8ba4b0";
                      pri_a = "#E46876";
                      pri_b = "#E6C384";
                      pri_c = "#87a987";
                      pri_d = "#7FB4CA";
                      pri_other = "#938AA9";
                      project = "#7AA89F";
                      context = "#c4b28a";
                      done = "#737c73";
                      matched = "#2D4F67";
                      due = "#DCA561";
                      overdue = "#C34043";
                      today = "#C34043";
                    };
                  };
                };
              };
            };
        };

        testScript = /* python */ ''
          machine1.systemctl("start network-online.target")
          machine1.wait_for_unit("network-online.target")
          machine1.succeed("su -- whitetie -c 'tuxedo ls'")
        '';
      };
    };
}

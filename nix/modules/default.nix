{
  self,
  ...
}:
{
  flake.homeModules = {
    tuxedo =
      {
        lib,
        pkgs,
        config,
        ...
      }:
      let
        inherit (pkgs.stdenv.hostPlatform) system;
        cfg = config.programs.tuxedo;
        tomlFormat = pkgs.formats.toml { };
      in
      {
        options = {
          programs.tuxedo = {
            enable = lib.mkEnableOption "tuxedo";

            package = lib.mkOption {
              default = self.packages.${system}.tuxedo;
              type = lib.types.package;
              description = "The {pkg}`tuxedo` package to use.";
            };

            ## XXX Is this dumb?
            settings = lib.mkOption {
              type = lib.types.nullOr tomlFormat.type;
              description = ''
                Generated config.toml written to
                {file}`$XDG_CONFIG_HOME/tuxedo/config.toml`

                See more at <https://github.com/LibereCode/tuxedo/tree/feat/quoted_config.toml#configuration>
              '';
              default = null;
              example = {
                #TODO:
              };
            };

            keybinds = lib.mkOption {
              type = lib.types.nullOr tomlFormat.type;
              description = ''
                Generated keybinds.toml written to
                {file}`$XDG_CONFIG_HOME/tuxedo/keybinds.toml`

                See more at <https://github.com/LibereCode/tuxedo/tree/feat/quoted_config.toml#keybindings>
              '';
              default = null;
              example = {
                normal = {
                  begin_edit_insert = [
                    "i"
                    "a"
                  ];
                  toggle_archive_view = "z";
                  archive_completed = "Z";
                };
              };
            };

            #TODO:
            themes = lib.mkOption {
              type = lib.types.attrsOf tomlFormat.type;
              description = ''
                Generated themes/*.toml written to
                {file}`$XDG_CONFIG_HOME/tuxedo/themes/<name>.toml`

                See more at <https://github.com/LibereCode/tuxedo/tree/feat/quoted_config.toml#themes>
              '';
              default = { };
              example = {
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

        config = lib.mkIf cfg.enable {
          home.packages = [ cfg.package ];

          xdg.configFile =
            { }
            // lib.optionalAttrs (cfg.settings != null) {
              ## cfg.settings
              "tuxedo/config.toml".source = pkgs.writers.writeTOML "tuxedo_config.toml" cfg.settings;
            }
            // lib.optionalAttrs (cfg.keybinds != null) {
              ## cfg.keybinds
              "tuxedo/keybinds.toml".source = pkgs.writers.writeTOML "tuxedo_keybinds.toml" cfg.keybinds;
            }
            ## cfg.themes.<name>
            // lib.mapAttrs' (
              n: v:
              lib.nameValuePair ("tuxedo/themes/" + n + ".toml") {
                source = pkgs.writers.writeTOML "tuxedo_theme_${n}.toml" v;
              }
            ) cfg.themes;
        };
      };
  };
}

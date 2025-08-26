{
  config,
  pkgs,
  lib ? pkgs.lib,
  ...
}:
let
  inherit (lib) types mkIf mkOption;

  cfg = config.programs.opencode;
in
{
  options = {
    programs.opencode = {
      enable = lib.mkEnableOption "opencode AI coding agent";

      package = lib.mkPackageOption pkgs "opencode" { };

      config = mkOption {
        type = types.attrs;
        default = { };
        example = lib.literalExpression ''
          {
            "$schema" = "https://opencode.ai/config.json";
            autoupdate = false;
            theme = "matrix";
            instructions = [ "CONTRIBUTING.md" ];
          }
        '';
        description = ''
          Configuration for opencode. Saved to `$XDG_CONFIG_HOME/opencode/opencode.json`.

          See available options: https://opencode.ai/docs/config/
        '';
      };

      instructions = mkOption {
        type = types.lines;
        default = "";
        description = ''
          Instructions to save as AGENTS.md
        '';
      };
    };
  };
  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];

    xdg.configFile."opencode/opencode.json".text = lib.strings.toJSON cfg.config;
    xdg.configFile."opencode/AGENTS.md".text = cfg.instructions;
  };
}

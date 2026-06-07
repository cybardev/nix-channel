{
  config,
  pkgs,
  lib ? pkgs.lib,
  ...
}:
let
  inherit (lib) types mkIf mkOption;

  cfg = config.programs.pi-coding-agent;
in
{
  options = {
    programs.pi-coding-agent = {
      enable = lib.mkEnableOption "pi AI coding agent";

      package = lib.mkPackageOption pkgs "pi-coding-agent" { };

      models = mkOption {
        type = types.attrs;
        default = { };
        example = lib.literalExpression ''
          {
            providers = {
              omlx = {
                baseUrl = "http://localhost:1234/v1";
                api = "openai-completions";
                apiKey = "placeholder";
                models = [
                  {
                    name = "Clod";
                    id = "tongrow/MLX-Qwopus3.5-9B-Coder-oQ4-fp16-mtp";
                    input = [ "text" ];
                    contextWindow = 262144;
                    maxTokens = 65536;
                  }
                ];
              };
            };
          }
        '';
        description = ''
          Configuration for pi. Saved to `~/.pi/agent/models.json`.

          See available options: https://pi.dev/docs/latest/models
        '';
      };

      instructions = mkOption {
        type = types.nullOr types.path;
        default = null;
        example = lib.literalExpression ''
          # INSTRUCTIONS
          Be concise.
        '';
        description = ''
          Instructions to save as AGENTS.md
        '';
      };
    };
  };
  config = mkIf cfg.enable {
    home = {
      packages = [ cfg.package ];
      file = {
        ".pi/agent/AGENTS.md".source = mkIf (cfg.instructions != null) cfg.instructions;
        ".pi/agent/models.json".text = lib.toJSON cfg.models;
      };
    };
  };
}

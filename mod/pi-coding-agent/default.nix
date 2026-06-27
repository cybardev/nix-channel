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

      settings = mkOption {
        type = types.attrs;
        default = { };
        example = lib.literalExpression ''
          {
            defaultProvider = "anthropic";
            defaultModel = "claude-sonnet-4-20250514";
            defaultThinkingLevel = "medium";
            theme = "dark";
            compaction = {
              enabled = true;
              reserveTokens = 16384;
              keepRecentTokens = 20000;
            };
            retry = {
              enabled = true;
              maxRetries = 3;
            };
            enabledModels = [ "claude-*" "gpt-4o" ];
            warnings.anthropicExtraUsage = true;
            packages = [ "pi-skills" ];
          }
        '';
        description = ''
          Settings for pi. Saved to `~/.pi/agent/settings.json`.

          See available options: https://pi.dev/docs/latest/settings
        '';
      };

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
          Model configuration for pi. Saved to `~/.pi/agent/models.json`.

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
        ".pi/agent/settings.json".text = lib.toJSON cfg.settings;
        ".pi/agent/models.json".text = lib.toJSON cfg.models;
      };
    };
  };
}

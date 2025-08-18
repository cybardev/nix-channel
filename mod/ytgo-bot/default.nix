{
  config,
  pkgs,
  lib ? pkgs.lib,
  ...
}:
let
  inherit (lib) types mkIf;

  cfg = config.services.ytgo-bot;

  botPackage = pkgs.callPackage ../../pkg/ytgo-bot/package.nix { };
in
{
  options = {
    services.ytgo-bot = {
      enable = lib.mkEnableOption "ytgo-bot service for ytgo Discord bot";

      token = lib.mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "BOT-TOKEN-FROM-DISCORD-DEVELOPER-PORTAL";
        description = ''
          Authentication token for the bot from the Discord developer portal.
        '';
      };
    };
  };
  config = mkIf cfg.enable {
    home.packages = [ botPackage ];

    systemd.user.services.ytgo-bot = mkIf pkgs.stdenv.isLinux {
      Unit = {
        Description = "Service for ytgo Discord bot";
        After = [ "network.target" ];
      };
      Service = {
        ExecStart = lib.getExe botPackage;
        Environment = [
          "BOT_TOKEN=${cfg.token}"
        ];
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
    };

    launchd.agents.ytgo-bot = mkIf pkgs.stdenv.isDarwin {
      enable = true;
      config = {
        ProgramArguments = [ (lib.getExe botPackage) ];
        EnvironmentVariables = {
          BOT_TOKEN = cfg.token;
        };
        KeepAlive = {
          Crashed = true;
          SuccessfulExit = false;
        };
        ProcessType = "Background";
      };
    };
  };
}

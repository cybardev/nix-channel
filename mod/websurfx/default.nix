{
  config,
  pkgs,
  lib ? pkgs.lib,
  ...
}:
let
  inherit (lib) types mkIf mkOption;

  cfg = config.services.websurfx;
in
{
  options = {
    services.websurfx = {
      enable = lib.mkEnableOption "Websurfx service for the meta search engine";

      package = lib.mkPackageOption pkgs "websurfx" { };

      configFile = mkOption {
        type = with types; nullOr (either str path);
        default = null;
        description = "Path to the configuration file read by websurfx.";
      };
    };
  };
  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];

    xdg.configFile."websurfx/config.lua".source = cfg.configFile;

    systemd.user.services.websurfx = mkIf pkgs.stdenv.isLinux {
      Unit = {
        Description = "Service for the Websurfx meta search engine";
        After = [ "network.target" ];
      };
      Service = {
        Type = "simple";
        Restart = "always";
        RestartSec = 1;
        ExecStart = lib.getExe cfg.package;
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
    };

    launchd.agents.websurfx = mkIf pkgs.stdenv.isDarwin {
      enable = true;
      config = {
        ProgramArguments = [
          (lib.getExe cfg.package)
        ];
        KeepAlive = {
          Crashed = true;
          SuccessfulExit = false;
        };
        ProcessType = "Background";
      };
    };
  };
}

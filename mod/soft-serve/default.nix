{
  config,
  pkgs,
  lib ? pkgs.lib,
  ...
}:
let
  inherit (lib) types mkIf mkOption;

  cfg = config.services.soft-serve;
in
{
  options = {
    services.soft-serve = {
      enable = lib.mkEnableOption "soft-serve service for the command line Git server";

      package = lib.mkPackageOption pkgs "soft-serve" { };

      environmentVariables = mkOption {
        type = types.attrsOf types.str;
        default = { };
        example = {
          SOFT_SERVE_GIT_LISTEN_ADDR = ":9418";
          SOFT_SERVE_HTTP_LISTEN_ADDR = ":23232";
          SOFT_SERVE_SSH_LISTEN_ADDR = ":23231";
          SOFT_SERVE_SSH_KEY_PATH = "ssh/soft_serve_host_ed25519";
          SOFT_SERVE_INITIAL_ADMIN_KEYS = "ssh-ed25519 AAAAC3NzaC1lZDI1...";
        };
        description = ''
          Set arbitrary environment variables for soft-serve.
        '';
      };
    };
  };
  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];
    home.sessionVariables = cfg.environmentVariables;

    systemd.user.services.soft-serve = mkIf pkgs.stdenv.isLinux {
      Unit = {
        Description = "Service for the soft-serve command line Git server";
        After = [ "network.target" ];
      };
      Service = {
        Type = "simple";
        Restart = "always";
        RestartSec = 1;
        ExecStart = "${lib.getExe cfg.package} serve";
        Environment = lib.mapAttrsToList (k: v: "${k}=${v}") cfg.environmentVariables;
      };
      Install = {
        WantedBy = [ "default.target" ];
      };
    };

    launchd.agents.soft-serve = mkIf pkgs.stdenv.isDarwin {
      enable = true;
      config = {
        ProgramArguments = [
          (lib.getExe cfg.package)
          "serve"
        ];
        EnvironmentVariables = cfg.environmentVariables;
        KeepAlive = {
          Crashed = true;
          SuccessfulExit = false;
        };
        ProcessType = "Background";
      };
    };
  };
}

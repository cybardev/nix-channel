{
  config,
  pkgs,
  lib ? pkgs.lib,
  ...
}:
let
  cfg = config.services.rift;
  tomlFmt = pkgs.formats.toml { };
in
{
  options = {
    services.rift = {
      enable = lib.mkEnableOption "tiling window manager for macos";

      package = lib.mkPackageOption pkgs "rift" { };

      config = lib.mkOption {
        type =
          with lib.types;
          oneOf [
            str
            path
            tomlFmt.type
            null
          ];
        default = "${cfg.package}/share/rift/config.toml";
        description = ''
          Options to add to the {file}`config.toml` file.

          See [documentation](https://github.com/acsandmann/rift/wiki/Config) for available configuration options.
        '';
      };
    };
  };

  config =
    let
      configFile =
        if cfg.config == null || lib.isPath cfg.config || lib.isString cfg.config then
          cfg.config
        else
          tomlFmt.generate "rift.toml" cfg.config;
    in
    lib.mkIf cfg.enable {
      home.packages = [ cfg.package ];

      home.file = lib.mkIf (cfg.config != null) {
        ".config/rift/config.toml".source = configFile;
      };

      launchd.agents.rift = {
        enable = true;
        config = {
          ProgramArguments = [
            (lib.getExe cfg.package)
          ]
          ++ lib.optionals (cfg.config != null) [
            "--config"
            "${configFile}"
          ];
          EnvironmentVariables = {
            RUST_LOG = "error,warn,info";
          };
          KeepAlive = {
            Crashed = true;
            SuccessfulExit = false;
          };
          ProcessType = "Background";
          StandardOutPath = "${config.home.homeDirectory}/Library/Logs/rift.log";
          StandardErrorPath = "${config.home.homeDirectory}/Library/Logs/rift.error.log";
          RunAtLoad = true;
        };
      };
    };
}

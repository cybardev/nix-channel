{
  config,
  pkgs,
  lib ? pkgs.lib,
  ...
}:
let
  cfg = config.programs.tenere;
  tomlFormat = pkgs.formats.toml { };
in
{
  options = {
    programs.tenere = {
      enable = lib.mkEnableOption "TUI for LLMs";

      package = lib.mkPackageOption pkgs "tenere" { };

      config = lib.mkOption {
        inherit (tomlFormat) type;
        default = { };
        example = {
          chatgpt = {
            model = "deepcogito-cogito-v1-preview-llama-3b";
            url = "http://localhost:1234/v1/chat/completions";
          };
          key_bindings = {
            show_help = "?";
            show_history = "h";
            new_chat = "n";
          };
        };
        description = ''
          Options to add to the {file}`config.toml` file.

          See [documentation](https://github.com/pythops/tenere?tab=readme-ov-file#%EF%B8%8F-configuration) for available configuration options.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];

    home.file = lib.mkIf (cfg.config != { }) (
      let
        source = tomlFormat.generate "config.toml" cfg.config;
      in
      {
        "Library/Application Support/tenere/config.toml" = lib.mkIf pkgs.stdenv.isDarwin {
          inherit source;
        };
        ".config/tenere/config.toml" = lib.mkIf pkgs.stdenv.isLinux {
          inherit source;
        };
      }
    );
  };
}

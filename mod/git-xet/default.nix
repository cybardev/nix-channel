{
  config,
  pkgs,
  lib ? pkgs.lib,
  ...
}:
let
  cfg = config.programs.git-xet;
in
{
  options = {
    programs.git-xet = {
      enable = lib.mkEnableOption "git-xet by huggingface";
      
      package = lib.mkPackageOption pkgs "git-xet" { };

      concurrency = lib.mkOption {
        description = "Number of concurrent transfers for Git LFS.";
        type = lib.types.int;
        default = 0;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];

    programs.git = {
      lfs.enable = true;

      settings = {
        lfs.concurrenttransfers = cfg.concurrency;

        lfs."customtransfer.xet" = {
          path = lib.getExe cfg.package;
          args = "transfer";
          concurrent = cfg.concurrency > 0;
        };
      };
    };
  };
}

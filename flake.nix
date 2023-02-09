{
  description = "My personal neovim config";

  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable"; };

  outputs = { nixpkgs, ... }: {
    hmModule = { options, config, lib, pkgs, ... }:
      let cfg = config.programs.devos.neovim;
      in {
        options.programs.devos.neovim.enable =
          lib.mkEnableOption "DevOS Neovim configuration";

        config = lib.mkIf cfg.enable {
          home.packages = with pkgs; [ tree-sitter ];

          programs.neovim.enable = true;

          xdg.configFile."nvim" = {
            source = ./.;
            recursive = true;
          };
        };
      };
  };
}

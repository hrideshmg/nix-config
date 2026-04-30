# Copyright (c) 2023 BirdeeHub
# Licensed under the MIT license

{
  description = "nixCats setup for my neovim config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixCats.url = "github:BirdeeHub/nixCats-nvim";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixCats,
      ...
    }@inputs:
    let
      inherit (nixCats) utils;
      luaPath = ./.;
      forEachSystem = utils.eachSystem nixpkgs.lib.platforms.all;

      extra_pkg_config = {
        # allowUnfree = true;
      };

      dependencyOverlays = [
        (utils.standardPluginOverlay inputs)
      ];

      categoryDefinitions =
        {
          pkgs,
          settings,
          categories,
          extra,
          name,
          mkPlugin,
          ...
        }@packageDef:
        {
          lspsAndRuntimeDeps = {
            general = with pkgs; [
              ruff
              djlint
              codespell
              python3Packages.python-lsp-server
              lua-language-server
              jdt-language-server
              docker-language-server
              docker-compose-language-service
              clang-tools
              ripgrep
              gopls
              nixd
              nixfmt

              stylua
              prettier
            ];
          };

          # This is for plugins that will load at startup without using packadd:
          startupPlugins = {
            gitPlugins = with pkgs.neovimPlugins; [ ];
            general = with pkgs.vimPlugins; [
              lazy-nvim
              nvim-lint

              telescope-nvim
              telescope-fzf-native-nvim
              telescope-ui-select-nvim
              telescope-undo-nvim

              indent-blankline-nvim
              nvim-colorizer-lua
              nvim-notify
              nvim-web-devicons
              rainbow-delimiters-nvim
              harpoon2
              nvim-tree-lua
              nvim-autopairs
              nvim-ts-autotag
              hop-nvim
              targets-vim
              comment-nvim
              mini-nvim
              git-conflict-nvim
              nvim-pqf

              nvim-notify
              onedark-nvim
              gitsigns-nvim
              openingh-nvim
              markdown-preview-nvim
              vim-sleuth
              which-key-nvim
              lualine-nvim
              vim-tmux-navigator

              nvim-lspconfig
              fidget-nvim
              lazydev-nvim
              nvim-cmp
              luasnip
              cmp_luasnip
              cmp-nvim-lsp
              cmp-path
              cmp-buffer
              friendly-snippets

              nvim-treesitter.withAllGrammars
              nvim-treesitter-textobjects
              conform-nvim
            ];
          };

          # not loaded automatically at startup.
          # use with packadd and an autocommand in config to achieve lazy loading
          optionalPlugins = {
            gitPlugins = with pkgs.neovimPlugins; [ ];
            general = with pkgs.vimPlugins; [ ];
          };
        };

      packageDefinitions = {
        nvim =
          { pkgs, name, ... }:
          {
            settings = {
              suffix-path = true;
              suffix-LD = true;
              wrapRc = true;
              # IMPORTANT:
              # your alias may not conflict with your other packages.
              aliases = [ "vim" ];
            };
            categories = {
              general = true;
              gitPlugins = true;
            };
          };
      };
      defaultPackageName = "nvim";
    in
    # see :help nixCats.flake.outputs.exports
    forEachSystem (
      system:
      let
        nixCatsBuilder = utils.baseBuilder luaPath {
          inherit
            nixpkgs
            system
            dependencyOverlays
            extra_pkg_config
            ;
        } categoryDefinitions packageDefinitions;
        defaultPackage = nixCatsBuilder defaultPackageName;
        # this is just for using utils such as pkgs.mkShell
        # The one used to build neovim is resolved inside the builder
        # and is passed to our categoryDefinitions and packageDefinitions
        pkgs = import nixpkgs { inherit system; };
      in
      {
        # these outputs will be wrapped with ${system} by utils.eachSystem

        # this will make a package out of each of the packageDefinitions defined above
        # and set the default package to the one passed in here.
        packages = utils.mkAllWithDefault defaultPackage;

        # choose your package for devShell
        # and add whatever else you want in it.
        devShells = {
          default = pkgs.mkShell {
            name = defaultPackageName;
            packages = [ defaultPackage ];
            inputsFrom = [ ];
            shellHook = "";
          };
        };

      }
    )
    // (
      let
        # we also export a nixos module to allow reconfiguration from configuration.nix
        nixosModule = utils.mkNixosModules {
          moduleNamespace = [ defaultPackageName ];
          inherit
            defaultPackageName
            dependencyOverlays
            luaPath
            categoryDefinitions
            packageDefinitions
            extra_pkg_config
            nixpkgs
            ;
        };
        # and the same for home manager
        homeModule = utils.mkHomeModules {
          moduleNamespace = [ defaultPackageName ];
          inherit
            defaultPackageName
            dependencyOverlays
            luaPath
            categoryDefinitions
            packageDefinitions
            extra_pkg_config
            nixpkgs
            ;
        };
      in
      {

        # these outputs will be NOT wrapped with ${system}

        # this will make an overlay out of each of the packageDefinitions defined above
        # and set the default overlay to the one named here.
        overlays = utils.makeOverlays luaPath {
          inherit nixpkgs dependencyOverlays extra_pkg_config;
        } categoryDefinitions packageDefinitions defaultPackageName;

        nixosModules.default = nixosModule;
        homeModules.default = homeModule;

        inherit utils nixosModule homeModule;
        inherit (utils) templates;
      }
    );

}

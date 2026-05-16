{
  pkgs,
  lib,
  ...
}:

let
  inherit (lib.generators) mkLuaInline;

  essRoot = "/home/martin/Documents/TUM/Masters/1.Semester/ESS";

  clangdArm = pkgs.writeShellScriptBin "clangd" ''
    unset CPATH
    unset C_INCLUDE_PATH
    unset CPLUS_INCLUDE_PATH
    unset OBJC_INCLUDE_PATH

    exec ${pkgs.llvmPackages.clang-unwrapped}/bin/clangd \
      --query-driver="$(command -v arm-none-eabi-gcc)" \
      "$@"
  '';
in
{
  programs.nvf.settings.vim.lsp = {
    enable = true;
    formatOnSave = false;
  };

  programs.nvf.settings.vim.languages = {
    enableTreesitter = true;

    bash.enable = true;
    clang.enable = true;
    css.enable = true;
    html = {
      enable = true;
      treesitter.autotagHtml = true;
    };
    json.enable = true;
    lua = {
      enable = true;
      lsp.lazydev.enable = true;
    };
    markdown.enable = true;
    nix.enable = true;
    python.enable = true;
    tex.enable = true;
    typescript.enable = true;
    yaml.enable = true;
  };

  programs.nvf.settings.vim.lsp.servers = {
    clangd = {
      cmd = lib.mkForce [ "${pkgs.clang-tools}/bin/clangd" ];
      root_dir = mkLuaInline ''
        function(bufnr, on_dir)
          local name = vim.api.nvim_buf_get_name(bufnr)
          if vim.startswith(name, "${essRoot}/") or name == "${essRoot}" then
            return
          end

          on_dir(vim.fs.root(bufnr, {
            ".git",
            ".clang-tidy",
            ".clang-format",
            "compile_commands.json",
            "compile_flags.txt",
            "configure.ac",
          }))
        end
      '';
    };

    clangd_ess = {
      enable = true;
      cmd = [ "${clangdArm}/bin/clangd" ];
      filetypes = [ "c" "cpp" "objc" "objcpp" "cuda" "proto" ];
      root_dir = mkLuaInline ''
        function(bufnr, on_dir)
          local name = vim.api.nvim_buf_get_name(bufnr)
          if not (vim.startswith(name, "${essRoot}/") or name == "${essRoot}") then
            return
          end

          on_dir(vim.fs.root(bufnr, {
            "compile_commands.json",
            "compile_flags.txt",
            ".git",
            "configure.ac",
          }) or "${essRoot}")
        end
      '';
    };
  };
}

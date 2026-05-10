{ ... }:

{
  programs.nvf.settings.vim.utility.motion.leap = {
    enable = true;
    mappings = {
      leapForwardTo = "s";
      leapFromWindow = "S";
      leapBackwardTo = null;
      leapForwardTill = null;
      leapBackwardTill = null;
    };
  };
}

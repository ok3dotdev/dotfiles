{ user, ... }:

{
  # Determinate already manages the Nix daemon, so nix-darwin shouldn't.
  nix.enable = false;

  nixpkgs.config.allowUnfree = true;
  nixpkgs.hostPlatform = "aarch64-darwin"; # use x86_64-darwin for Intel CPU

  system.primaryUser = user;
  users.users.${user} = {
    home = "/Users/${user}";
  };
  system.stateVersion = 6;
  system.defaults = {
    NSGlobalDomain = {
      AppleInterfaceStyle = "Dark";
      KeyRepeat = 2;          # fast key repeat
      InitialKeyRepeat = 15;  # short delay before repeat
      _HIHideMenuBar = true;  # auto-hide the menu bar
      AppleShowAllExtensions = true;
    };
    dock.autohide = true;
    finder.FXPreferredViewStyle = "Nlsv";  # list view by default
    finder.CreateDesktop = false;          # clean desktop
    trackpad.Clicking = true;              # tap to click
  };
  nix-homebrew = {
    enable = true;
    inherit user;
    # You already had a real Homebrew install at /opt/homebrew before adopting
    # this config. autoMigrate converts it in place under nix-homebrew's
    # management, keeping installed packages, instead of requiring a full
    # uninstall-and-reinstall.
    autoMigrate = true;
  };
  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";  # remove anything not listed here
    onActivation.autoUpdate = true;
    onActivation.extraFlags = [ "--force" ];
    taps = [
      "antoniorodr/memo"
      "steipete/tap"
    ];
    brews = [
      "herdr"          # wezterm/nvim mouse+escape fixes, needed for the theme setup
      "go"
      "postgresql@17"
      "redis"
      "sox"
      "tmux"
      "uv"
      "whisper.cpp"  # "whisper-cpp" is just an old alias for this same formula
      "yt-dlp"
      "steipete/tap/summarize"
      "steipete/tap/imsg"
      "steipete/tap/remindctl"
      "antoniorodr/memo/memo"
    ];
    casks = [
      "wezterm"
      "ngrok"
      # font-meslo-lg-nerd-font dropped: the adopted wezterm theme uses Hack
      # Nerd Font, already provided by home.nix's nerd-fonts.hack package.
      # claude-code dropped: you already run it from ~/.local/bin (npm
      # install), adding the cask would just be a second, redundant copy.
    ];
  };
}

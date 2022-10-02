{ config, pkgs, ... }:

let
    plateformSpecificPackages = if (builtins.match ".*WSL2.*" (builtins.readFile /proc/version )) == null
    then [# We are *not* in WSL
      pkgs.teams
      pkgs.discord
      pkgs.vscode
      pkgs.htop
      pkgs.clip
    ]
    else [ # We *are* in WSL
      pkgs.wslu
    ];
    
    commonPackages = [
      pkgs.fish
      pkgs.openssh
      pkgs.git
      pkgs.file
      pkgs.gh
      pkgs.micro
      pkgs.powershell
      pkgs.rnix-lsp
      pkgs.any-nix-shell
    ];

in {
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "cola";
  home.homeDirectory = "/home/cola";

  nixpkgs.config.allowUnfree = true;

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = builtins.import ./stateVersion.nix;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.packages = builtins.concatLists [ commonPackages plateformSpecificPackages ];

  programs.fish.enable = true;
  programs.fish.shellInit = builtins.readFile ./fish/shellInit.fish;

  programs.bash.enable = true;
  programs.bash.initExtra = ''source /home/cola/.config/nixpkgs/bash/bashrc'';

  programs.git.enable = true;
  programs.git.aliases = {
  	tree = "log --all --decorate --oneline --graph";
  	pall = "push --all";
  };
  programs.git.userEmail = "github@rondier.io";
  programs.git.userName = "COLAMAroro";

  home.sessionVariables = {
    EDITOR = "micro";
  };
}

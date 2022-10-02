{ config, pkgs, ... }:

{
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
  home.stateVersion = "22.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.packages = [
	pkgs.fish
	pkgs.htop
	pkgs.openssh
	pkgs.git
	pkgs.nodejs
	pkgs.file
#	pkgs.vscode
	pkgs.gh
  ];

  programs.fish.enable = true;
  programs.fish.shellInit = builtins.readFile ./fish/shellInit.fish;

  programs.bash.enable = true;
  programs.bash.initExtra = ''source /home/cola/.config/nixpkgs/bash/bashrc'';
}

# programs
{ pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    # utils
    zsh
    htop
    nano
    git
    nmap
    nettools
    usbutils
    gnome.gnome-session
    # gnomeExtensions.dash-to-dock
  ];
 
  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
  };
}

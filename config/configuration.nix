# configuration
{ config, pkgs, ... }:

{
  imports = [
    ./users.nix 
    ./networking.nix
    ./programs.nix
    ./ssh.nix

    # desktop and remote desktop
    ./xrdp.nix
    ./modules/xfce.nix
    # ./modules/gnome.nix
    # ./modules/plasma5.nix
  ];

  boot.isContainer = true;

  system.stateVersion = "23.11";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}

# configuration
{ config, pkgs, ... }:

{
  imports = [
    ./users.nix 

    ./networking.nix

    ./gnome.nix
    ./gnome-remote-desktop.nix
  
    ./programs.nix
    ./ssh.nix
  ];

  boot.isContainer = true;

  system.stateVersion = "23.11";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}

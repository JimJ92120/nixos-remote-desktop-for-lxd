# gnome
{ pkgs, ... }:

{
  services.xserver = {
    desktopManager = {
      gnome = {
        enable = true;
      };
    };
  };

  # add some gnome packages
  environment.systemPackages = with pkgs; [
    # or use gnome.$EXTENSION or gnomeExtensions.$EXTENSION
    gnome.gnome-terminal
    gnomeExtensions.git
  ];

  # remove default packages from basic NixOS Desktop install
  environment.gnome.excludePackages = (with pkgs; [
    #gnome-photos
    gnome-tour
    xterm
  ]) ++ (with pkgs.gnome; [
    #cheese # webcam tool
    #gnome-music
    #gnome-terminal
    #gedit # text editor
    gnome-contacts
    gnome-weather
    gnome-maps
    epiphany # web browser
    geary # email reader
    #evince # document viewer
    #gnome-characters
    totem # video player
  ]);
}

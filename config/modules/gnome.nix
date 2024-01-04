# gnome
# https://nixos.wiki/wiki/GNOME
{ pkgs, ... }:

{
  services.xrdp = {
    defaultWindowManager = "gnome-session";
  };

  services.xserver = {
    enable = true;

    displayManager = {
      gdm = {
        enable = true;
        # x11
        wayland = false;
      };
    };

    desktopManager = {
      gnome = {
        enable = true;
      };
    };
  };

  # may causes black screen if enabled
  systemd.services = {
    "getty@tty1".enable = false;
    "autovt@tty1".enable = false;
  };

  ### packages
  # add some gnome packages
  environment.systemPackages = with pkgs; [
    # required for xrdp
    gnome.gnome-session

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

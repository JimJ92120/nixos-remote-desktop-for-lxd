# xfce
# https://nixos.wiki/wiki/xfce
{ pkgs, ... }:

{
  services.xrdp = {
    defaultWindowManager = "xfce4-session";
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
      xterm.enable = false;
      xfce.enable = true;
    };
  };
}

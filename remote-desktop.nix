# remote-desktop
# https://nixos.wiki/wiki/Remote_Desktop
{ pkgs, ... }:

{
  services.xrdp = {
    enable = true;
    openFirewall = true;
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

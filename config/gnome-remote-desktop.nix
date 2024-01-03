# remote-desktop
{ pkgs, ... }:

{
  services.xrdp = {
    enable = true;
    openFirewall = true;
    defaultWindowManager = "gnome-session";
  }; 

  services.xserver = {
    enable = true;

    displayManager = {
      # gdm isn't working, even with wayland off...
      sddm = {
        enable = true;
      };

      defaultSession = "gnome-xorg";
    };
  };

  systemd.services = {
    "getty@tty1".enable = false;
    "autovt@tty1".enable = false;
  };

  # gnome
  services.gnome = {
    gnome-remote-desktop.enable = true;
    gnome-browser-connector.enable = true;
  };
      
  environment.systemPackages = with pkgs; [
    gnome.gnome-session
  ];
}

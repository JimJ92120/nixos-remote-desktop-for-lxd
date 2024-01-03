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

      gdm = {
        wayland = false;
      };

      defaultSession = "gnome";
    };
  };

  systemd.services = {
    "getty@tty1".enable = false;
    "autovt@tty1".enable = false;
  };
        
  environment.systemPackages = with pkgs; [
    gnome.gnome-session
  ];
}

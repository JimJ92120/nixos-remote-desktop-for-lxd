# plasma 5 (X11 only)
# see KDE Plasma: https://nixos.wiki/wiki/KDE#Excluding_some_KDE_Plasma_applications_from_the_default_install
{
  services.xrdp = {
    defaultWindowManager = "startplasma-x11";
  };

  services.xserver = {
    enable = true;

    displayManager = {
      sddm = {
        enable = true;
      };
    };

    desktopManager = {
      plasma5 = {
        enable = true;
      };
    };
  };
}

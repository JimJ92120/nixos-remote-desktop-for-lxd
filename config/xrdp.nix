# xrdp
# https://nixos.wiki/wiki/Remote_Desktop
{
  services.xrdp = {
    enable = true;
    openFirewall = true;
  };
}

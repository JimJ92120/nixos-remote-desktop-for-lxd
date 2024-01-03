# users
{ pkgs, ... }:

let
  MAIN_USER = "john";
  MAIN_USER_PASSWORD = "doe";
in {
  nix.settings.trusted-users = [ "root" MAIN_USER];

  users = {
    mutableUsers = true;

    users."${MAIN_USER}" = {
      password = MAIN_USER_PASSWORD;
      isNormalUser = true;
      extraGroups = [ "wheel"];
      shell = pkgs.zsh;
      
      packages = with pkgs; [
        # use home-manager?
      ];
    };
  };
}

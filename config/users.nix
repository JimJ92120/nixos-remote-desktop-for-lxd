# users
{ pkgs, ... }:

let
  MAIN_USER = "john";
  MAIN_USER_PASSWORD = "doe";
in {
  nix.settings.trusted-users = [ "root" "john" ];

  users = {
    mutableUsers = true;

    users."${MAIN_USER}" = {
      # password = MAIN_USER_PASSWORD;
      isNormalUser = true;
      description = "jim";
      extraGroups = [ "wheel"];
      shell = pkgs.zsh;
      
      packages = with pkgs; [
        # use home-manager?
      ];
    };
  };
}

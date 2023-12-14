{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    asusctl
  ];

  services.asusd.enable = true;
}

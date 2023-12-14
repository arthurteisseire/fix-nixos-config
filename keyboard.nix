{ config, lib, pkgs, ... }:

let
  compiledLayout = pkgs.runCommand "keyboard-layout" {} ''
    ${pkgs.xorg.xkbcomp}/bin/xkbcomp -I/home/arthur/.config/xkb ${/home/arthur/.config/xkb/us-custom.xkb} $out
  '';
in
{
  console.useXkbConfig = true;

  services.xserver.displayManager.sessionCommands = "${pkgs.xorg.xkbcomp}/bin/xkbcomp -I/home/arthur/.config/xkb ${compiledLayout} $DISPLAY";
}

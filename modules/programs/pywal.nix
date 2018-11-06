{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.programs.pywal;

in

{
  meta.maintainers = [ maintainers.refnil ];

  options.programs.pywal = {
    enable = mkEnableOption "pywal, Generate and change colorschemes on the fly";

    enableBashIntegration = mkOption {
      default = true;
      type = types.bool;
      description = ''
        Whether to enable Bash integration.
      '';
    };

    enableZshIntegration = mkOption {
      default = true;
      type = types.bool;
      description = ''
        Whether to enable Zsh integration.
      '';
    };

    enableFishIntegration = mkOption {
      default = true;
      type = types.bool;
      description = ''
        Whether to enable Fish integration.
      '';
    };

    i3 = mkOption {
       default = true;
       type = types.bool;
       description = ''
         Whether to enable i3 integration
       '';
    };

  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.pywal ];

    programs.bash.initExtra = mkIf cfg.enableBashIntegration ''
      '';

    programs.zsh.initExtra = mkIf cfg.enableZshIntegration ''
    '';

    programs.fish.shellInit = mkIf cfg.enableFishIntegration ''
      cat ~/.cache/wal/sequences &
    '';

    # This color switch could be integrated to the color submodule 
    # but I haven't took the time to try yet
    xsession.windowManager.i3.extraConfig = mkIf cfg.i3 ''
    set_from_resource $fg i3wm.color7 #f0f0f0
set_from_resource $bg i3wm.color2 #f0f0f0

# class                 border  backgr. text indicator child_border
client.focused          $bg     $bg     $fg  $bg       $bg
client.focused_inactive $bg     $bg     $fg  $bg       $bg
client.unfocused        $bg     $bg     $fg  $bg       $bg
client.urgent           $bg     $bg     $fg  $bg       $bg
client.placeholder      $bg     $bg     $fg  $bg       $bg

client.background       $bg
    '';
  };
}

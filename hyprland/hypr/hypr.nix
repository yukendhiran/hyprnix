{pkgs, config, lib, inputs, ...}: 
{
  wayland.windowManager.hyprland.extraConfig = ''
    #monitor = DP-1, 1440x900@59, 0x0, 1
    # monitor = DP-1, 1024x768@59, 0x0, 1
    # monitor = DP-1,1366x768@60,0x0,1
    monitor = ,preferred,auto,auto
    


    # Start up apps on boot
    exec-once = /usr/libexec/polkit-gnome-authentication-agent-1
    exec-once = ags -b hypr
    exec-once = ~/.profile
    # exec-once = flatpak run com.transmissionbt.Transmission
    exec-once = swww init
    exec-once = wl-paste --type text --watch cliphist store #Stores only text data
    # exec-once = wl-paste --type image --watch cliphist store #Stores only image data
    exec-once = wl-paste --type image --watch
    exec-once = systemctl --user start graphical-session.target
    exec-once = systemctl start polkit-gnome-authentication-agent-1 

    # Settings
    general {
      layout = dwindle
      resize_on_border = true
    }

    misc {
      layers_hog_keyboard_focus = false
      layers_hog_keyboard_focus = true
      disable_splash_rendering = true
    }

    input {
      kb_layout = us
      #kb_model = pc104
      follow_mouse = 1
      touchpad {
        natural_scroll = yes
      }
      sensitivity = 0
    }

    binds {
      allow_workspace_cycles = true
    }

    dwindle {
      pseudotile = yes
      preserve_split = yes
      # no_gaps_when_only = yes
    }

    master {
      new_status = master
      # no_gaps_when_only = yes
    }

    gestures {
      workspace_swipe = on
      workspace_swipe_fingers = 3
    }

    # Theme
    decoration {
      drop_shadow = yes
      shadow_range = 8
      shadow_render_power = 2
      col.shadow = rgba(00000044)

      dim_inactive = false

      #blur {
        # enabled = true
        #size = 8
        #passes = 3
        #new_optimizations = on
        #noise = 0.01
        #contrast = 0.9
        #brightness = 0.8
      }
    }

    animations {
      enabled = yes
      bezier = myBezier, 0.05, 0.9, 0.1, 1.05
      animation = windows, 1, 5, myBezier
      animation = windowsOut, 1, 7, default, popin 80%
      animation = border, 1, 10, default
      animation = fade, 1, 7, default
      animation = workspaces, 1, 6, default
    }

    plugin {
      hyprbars {
        bar_color = rgb(2a2a2a)
        bar_height = 28
        col_text = rgba(ffffffdd)
        bar_text_size = 11
        bar_text_font = Ubuntu Nerd Font 
        buttons {
          button_size = 11
          col.maximize = rgba(ffffff11)
          col.close = rgba(ff111133)
        }
      }
    }

    # Window rules
    windowrule = float, ^(Rofi)$
    windowrule = float, ^(org.gnome.Calculator)$
    windowrule = float, ^(thunar)$
    windowrule = float, ^(eww)$
    windowrule = float, ^(pavucontrol)$
    windowrule = float, ^(nm-connection-editor)$
    windowrule = float, ^(blueberry.py)$
    windowrule = float, ^(org.gnome.Settings)$
    windowrule = float, ^(org.gnome.design.Palette)$
    windowrule = float, ^(Color Picker)$
    windowrule = float, ^(Network)$
    windowrule = float, ^(xdg-desktop-portal)$
    windowrule = float, ^(xdg-desktop-portal-gnome)$
    windowrule = float, ^(transmission-gtk)$
    windowrule = float, ^(ags)$

    # Keybindings
    $main = SUPER
    $meta = ALT

    # AGS
    bind = CTRL SHIFT, R, exec, ags -b hypr quit; ags -b hypr
    bind = SUPER, D, exec, ags -b hypr toggle-window overview
    bind = , XF86PowerOff, exec, ags -b hypr toggle-window powermenu
    bind = SUPER, R, exec, ags -b hypr toggle-window applauncher 
    bind  = , XF86Launch4, exec, ags -b hypr -r "recorder.start()"
    # bind  = , XF86Launch1, exec, 

    # Print
    # Laptop
    bindle = , XF86MonBrightnessUp,     exec, ags -b hypr -r "brightness.screen += 0.05; indicator.display()"
    bindle = , XF86MonBrightnessDown,   exec, ags -b hypr -r "brightness.screen -= 0.05; indicator.display()"
    bindle = , XF86KbdBrightnessUp,     exec, ags -b hypr -r "brightness.kbd++; indicator.kbd()"
    bindle = , XF86KbdBrightnessDown,   exec, ags -b hypr -r "brightness.kbd--; indicator.kbd()"
    bindle = , XF86AudioRaiseVolume,    exec, ags -b hypr -r "audio.speaker.volume += 0.05; indicator.speaker()"
    bindle = , XF86AudioLowerVolume,    exec, ags -b hypr -r "audio.speaker.volume -= 0.05; indicator.speaker()"
    bindl  = , XF86AudioPlay,           exec, ags -b hypr -r "mpris.players.pop()?.playPause()"
    bindl  = , XF86AudioStop,           exec, ags -b hypr -r "mpris.players.pop()?.stop()"
    bindl  = , XF86AudioPause,          exec, ags -b hypr -r "mpris.players.pop()?.pause()"
    bindl  = , XF86AudioPrev,           exec, ags -b hypr -r "mpris.players.pop()?.previous()"
    bindl  = , XF86AudioNext,           exec, ags -b hypr -r "mpris.players.pop()?.next()"
    bindl  = , XF86AudioMicMute,        exec, ags -b hypr -r "audio.microphone.isMuted = !audio.microphone.isMuted" 

    # bind = SUPER SHIFT, P, exec, ags -b hypr run-js "ags.Service.Recorder.screenshot()"
    bind = SUPER SHIFT, P, exec, sleep 1 && grimblast --notify save area ~/Pictures/Screenshots/$(date +'%s_screenshot.png') &

    # Launchers
    bind = SUPER, Return, exec, kitty
    bind = SUPER, W, exec, floorp
    bind = SUPER, E, exec, nautilus
    bind = SUPER, C, exec, cliphist list | rofi -dmenu | cliphist decode | wl-copy
    bind = ALT, G, exec, rofi -modi emoji -show emoji
    bind = ALT, W, exec, ~/.config/swww/changeWalls
    # bind = ALT, L, exec, wlogout
    bind = ALT, SPACE, exec, pkill rofi || ~/.config/rofi/launchers/type-6/launcher.sh
    bind = ALT, S, exec, spotify

    # Bindings
    bind = CTRL ALT, Delete, exit
    bind = SUPER, Q, killactive
    bind = SUPER, Space, togglefloating
    bind = SUPER, F, fullscreen
    bind = SUPER, O, fakefullscreen
    bind = SUPER, S, togglesplit

    # Move focus with mainMod + arrow keys
    bind = SUPER, left, movefocus, l
    bind = SUPER, right, movefocus, r
    bind = SUPER, up, movefocus, u
    bind = SUPER, down, movefocus, d

    # Switch workspaces with mainMod + [0-9]
    bind = SUPER, period, workspace, e+1
    bind = SUPER, comma, workspace,e-1
    bind = SUPER, 1, workspace, 1
    bind = SUPER, 2, workspace, 2
    bind = SUPER, 3, workspace, 3
    bind = SUPER, 4, workspace, 4
    bind = SUPER, 5, workspace, 5
    bind = SUPER, 6, workspace, 6
    bind = SUPER, 7, workspace, 7
    bind = SUPER, 8, workspace, 8
    bind = SUPER, 9, workspace, 9

    # Window
    bind =,right,resizeactive,15 0
    bind =,left,resizeactive,-15 0
    bind =,up,resizeactive,0 -15
    bind =,down,resizeactive,0 15
  #  bind = SUPER ALT,  k, moveactive, 0 -20
  #  bind = SUPER ALT,  j, moveactive, 0 20
  #  bind = SUPER ALT,  l, moveactive, 20 0
  #  bind = SUPER ALT,  h, moveactive, -20 0


    # Move active window to a workspace with mainMod + CTRL + [0-9]
    bind = SUPER CTRL, 1, movetoworkspace, 1
    bind = SUPER CTRL, 2, movetoworkspace, 2
    bind = SUPER CTRL, 3, movetoworkspace, 3
    bind = SUPER CTRL, 4, movetoworkspace, 4
    bind = SUPER CTRL, 5, movetoworkspace, 5
    bind = SUPER CTRL, 6, movetoworkspace, 6
    bind = SUPER CTRL, 7, movetoworkspace, 7
    bind = SUPER CTRL, 8, movetoworkspace, 8
    bind = SUPER CTRL, 9, movetoworkspace, 9
    bind = SUPER CTRL, 0, movetoworkspace, 10
    bind = SUPER CTRL, left, movetoworkspace, -1
    bind = SUPER CTRL, right, movetoworkspace, +1

    # same as above, but doesnt switch to the workspace
    bind = $mainMod SHIFT, 1, movetoworkspacesilent, 1
    bind = $mainMod SHIFT, 2, movetoworkspacesilent, 2
    bind = $mainMod SHIFT, 3, movetoworkspacesilent, 3
    bind = $mainMod SHIFT, 4, movetoworkspacesilent, 4
    bind = $mainMod SHIFT, 5, movetoworkspacesilent, 5
    bind = $mainMod SHIFT, 6, movetoworkspacesilent, 6
    bind = $mainMod SHIFT, 7, movetoworkspacesilent, 7
    bind = $mainMod SHIFT, 8, movetoworkspacesilent, 8
    bind = $mainMod SHIFT, 9, movetoworkspacesilent, 9
    bind = $mainMod SHIFT, 0, movetoworkspacesilent, 10

    # Move/resize windows with mainMod + LMB/RMB and dragging
    bindm = SUPER, mouse:272, movewindow
    bindm = SUPER, mouse:273, resizewindow
    '';
#  FIXME: wayland.windowManager.hyprland.plugins = [
#   inputs.hyprland-plugins.packages.${pkgs.system}.hyprbars
#   "/absolute/path/to/plugin.so"
# ];
}

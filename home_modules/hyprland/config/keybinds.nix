{ config, ... }:
let
  mainMod = config.hyprland.mainMod;
in
{
  wayland.windowManager.hyprland.extraConfig = ''
    local mainMod = "${mainMod}"

    hl.bind(mainMod .. " + Z", hl.dsp.exec_cmd("spotify --disable-gpu"))
    hl.bind(mainMod .. " + B", hl.dsp.exec_cmd("firefox"))
    hl.bind(mainMod .. " + N", hl.dsp.exec_cmd("obsidian --disable-gpu"))

    hl.bind(mainMod .. " + I", hl.dsp.exec_cmd("networkmanager_dmenu -i"))
    hl.bind(mainMod .. " + W", hl.dsp.exec_cmd("rofi -i -show window"))
    hl.bind(mainMod .. " + R", hl.dsp.exec_cmd("rofi -i -show drun"))
    hl.bind(mainMod .. " + E", hl.dsp.exec_cmd("rofi -show calc -modi calc -no-show-match -no-sort"))
    hl.bind(mainMod .. " + period", hl.dsp.exec_cmd("rofimoji --skin-tone neutral"))

    hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd("foot"))
    hl.bind(mainMod .. " + SHIFT + Return", hl.dsp.exec_cmd("foot --title floating_foot"))

    hl.bind("Print", hl.dsp.exec_cmd("grimblast copy area"))
    hl.bind("SHIFT + Print", hl.dsp.exec_cmd("grimblast save area && notify-send -i folder-pictures 'Saved Screenshot'"))

    hl.bind(mainMod .. " + X", hl.dsp.exec_cmd("swaylock"))

    hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl -p spotify,firefox,%any play-pause"), { locked = true })
    hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl -p spotify,firefox,%any play-pause"), { locked = true })
    hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
    hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
    hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%-"), { locked = true, repeating = true })
    hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 2%+"), { locked = true, repeating = true })

    hl.bind(mainMod .. " + Q", hl.dsp.window.close())
    hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.exit())
    hl.bind(mainMod .. " + SPACE", hl.dsp.window.float({ action = "toggle" }))
    hl.bind(mainMod .. " + S", hl.dsp.layout("togglesplit"))
    hl.bind(mainMod .. " + M", hl.dsp.window.fullscreen({ mode = "maximized" }))
    hl.bind(mainMod .. " + SHIFT + M", hl.dsp.window.fullscreen({ mode = "fullscreen" }))
    hl.bind(mainMod .. " + O", hl.dsp.window.set_prop({ window = "activewindow", prop = "opaque", value = "toggle" }))

    hl.bind(mainMod .. " + a", hl.dsp.workspace.toggle_special(""))
    hl.bind(mainMod .. " + SHIFT + a", hl.dsp.window.move({ workspace = "special" }))
    hl.bind(mainMod .. " + c", hl.dsp.window.center())

    hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }))
    hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))
    hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }))
    hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }))

    hl.bind(mainMod .. " + SHIFT + H", hl.dsp.window.move({ direction = "left" }))
    hl.bind(mainMod .. " + SHIFT + L", hl.dsp.window.move({ direction = "right" }))
    hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.move({ direction = "up" }))
    hl.bind(mainMod .. " + SHIFT + J", hl.dsp.window.move({ direction = "down" }))

    hl.bind(mainMod .. " + CTRL + H", hl.dsp.window.resize({ x = -20, y = 0, relative = true }), { repeating = true })
    hl.bind(mainMod .. " + CTRL + L", hl.dsp.window.resize({ x = 20, y = 0, relative = true }), { repeating = true })
    hl.bind(mainMod .. " + CTRL + K", hl.dsp.window.resize({ x = 0, y = -20, relative = true }), { repeating = true })
    hl.bind(mainMod .. " + CTRL + J", hl.dsp.window.resize({ x = 0, y = 20, relative = true }), { repeating = true })

    hl.bind(mainMod .. " + SHIFT + CTRL + H", hl.dsp.window.resize({ x = -80, y = 0, relative = true }), { repeating = true })
    hl.bind(mainMod .. " + SHIFT + CTRL + L", hl.dsp.window.resize({ x = 80, y = 0, relative = true }), { repeating = true })
    hl.bind(mainMod .. " + SHIFT + CTRL + K", hl.dsp.window.resize({ x = 0, y = -80, relative = true }), { repeating = true })
    hl.bind(mainMod .. " + SHIFT + CTRL + J", hl.dsp.window.resize({ x = 0, y = 80, relative = true }), { repeating = true })

    for workspace = 1, 10 do
      local key = workspace % 10
      hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = workspace }))
      hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = workspace }))
    end

    hl.bind(mainMod .. " + Down", hl.dsp.exec_cmd("brightnessctl --min-value=2 s 3%- -n 1"), { repeating = true })
    hl.bind(mainMod .. " + Up", hl.dsp.exec_cmd("brightnessctl s +3% -n 1"), { repeating = true })

    hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
    hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
  '';
}

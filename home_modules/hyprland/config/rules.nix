{ ... }:
{
  wayland.windowManager.hyprland.extraConfig = ''
    hl.window_rule({ match = { workspace = "name:special" }, float = true })

    hl.window_rule({
      match = { class = "^(foot)$" },
      opacity = "0.85 override 0.8 override",
    })
    hl.window_rule({
      match = { title = "^tmux.*" },
      opacity = "1.0 override 1.0 override",
    })

    hl.window_rule({ match = { class = "^(firefox)$", title = "^(Library)$" }, float = true })
    hl.window_rule({ match = { class = "^(.blueman-manager-wrapped)$" }, float = true })
    hl.window_rule({ match = { class = "^(firefox)$", title = "^(OpenCode)$" }, float = true })
    hl.window_rule({ match = { class = "^(firefox)$", title = "claude" }, float = true })
    hl.window_rule({
      match = { title = "^(floating_foot)$" },
      float = true,
      size = { "monitor_w*0.4", "monitor_h*0.4" },
    })
    hl.window_rule({ match = { title = "^(Save As)$" }, float = true })
    hl.window_rule({ match = { title = "^(Open)$" }, float = true })
    hl.window_rule({ match = { title = "^(blueman)$" }, float = true })
    hl.window_rule({ match = { title = "^(KeePassXC - Browser Access Request)$" }, float = true })
    hl.window_rule({ match = { title = "^(Open File(s)?)$" }, float = true })
    hl.window_rule({ match = { title = "^(Choose Files)$" }, float = true })
    hl.window_rule({ match = { title = "^(Save File)$" }, float = true })

    hl.window_rule({ match = { title = "^(scrcpy)$" }, tile = true })
  '';
}

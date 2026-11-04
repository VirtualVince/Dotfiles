-- Hyprland 0.57+ Lua config.
-- Ported 1:1 from hyprland.conf (Hyprlang), which 0.57 no longer reads.
-- The old file is kept alongside as hyprland.conf for reference.
-- API reference: /usr/share/hypr/stubs/hl.meta.lua and https://wiki.hypr.land/configuring/

---------------------
---- ENVIRONMENT ----
---------------------

hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")

hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("GBM_BACKEND", "nvidia-drm")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
hl.env("WLR_NO_HARDWARE_CURSORS", "1")

hl.env("QT_QPA_PLATFORM", "wayland")
hl.env("SDL_VIDEODRIVER", "wayland")
hl.env("CLUTTER_BACKEND", "wayland")


------------------
---- MONITORS ----
------------------

-- Matched by description, not connector name: connector names depend on GPU
-- driver load order (HDMI-A-3/DP-3 before nvidia was in the initramfs,
-- HDMI-A-1/DP-1 after). waybar + hyprpaper only take names, so they use
-- HDMI-A-1/DP-1.
local acer = "desc:Acer Technologies Acer K272HL T0BAA0024204"
local dell = "desc:Dell Inc. DELL 2007FP C953681N2JPS"

-- Fallback for any monitor not matched below (e.g. on another machine).
hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = 1,
})

-- Acer (main)
hl.monitor({
    output   = acer,
    mode     = "1920x1080@60",
    position = "0x0",
    scale    = 1,
})

-- Dell 2007FP (portrait, left)
hl.monitor({
    output    = dell,
    mode      = "1600x1200@60",
    position  = "-1200x-260",
    scale     = 1,
    transform = 1,
})


-------------------------------------
---- WORKSPACE + MONITOR MAPPING ----
-------------------------------------

hl.workspace_rule({ workspace = "1", monitor = acer, default = true })
for i = 2, 5 do
    hl.workspace_rule({ workspace = tostring(i), monitor = acer })
end
for i = 6, 10 do
    hl.workspace_rule({ workspace = tostring(i), monitor = dell })
end


---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER"

-- Workspace switching: SUPER + 1..9,0 -> workspaces 1..10
-- Move window to workspace: SUPER + SHIFT + 1..9,0
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key,         hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

hl.bind(mainMod .. " + RETURN",    hl.dsp.exec_cmd("kitty"))
hl.bind(mainMod .. " + Q",         hl.dsp.window.close())
hl.bind(mainMod .. " + D",         hl.dsp.exec_cmd("rofi -show drun"))
hl.bind(mainMod .. " + F",         hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))
hl.bind(mainMod .. " + V",         hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + b",         hl.dsp.exec_cmd("brave"))
hl.bind(mainMod .. " + n",         hl.dsp.exec_cmd("nvim"))
hl.bind(mainMod .. " + o",         hl.dsp.exec_cmd("obsidian"))
hl.bind(mainMod .. " + r",         hl.dsp.exec_cmd("obs"))
hl.bind(mainMod .. " + s",         hl.dsp.exec_cmd("steam"))
hl.bind(mainMod .. " + m",         hl.dsp.exec_cmd("pavucontrol"))
hl.bind(mainMod .. " + SHIFT + f", hl.dsp.exec_cmd("thunar"))
hl.bind(mainMod .. " + SHIFT + s", hl.dsp.exec_cmd("~/.screenshot.sh"))
hl.bind(mainMod .. " + SHIFT + k", hl.dsp.exec_cmd("systemctl suspend"))

-- Media keys (headset power button); locked = works while screen is locked
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })


---------------
---- INPUT ----
---------------

hl.config({
    input = {
        follow_mouse  = 1,
        mouse_refocus = false,
    },
})


-------------------
---- AUTOSTART ----
-------------------

hl.on("hyprland.start", function()
    hl.exec_cmd("waybar")
    hl.exec_cmd("dunst")
    hl.exec_cmd("nm-applet")
    hl.exec_cmd("hyprpaper -c ~/.config/hypr/hyprpaper.conf")

    -- Mark the Acer as the XWayland primary output. Wine/Proton picks the RandR
    -- primary as the Windows primary display; without this, XWayland normalises
    -- Dell (top-left in layout terms) to 0,0 and games fullscreen onto the
    -- portrait Dell. Delayed so XWayland is up before xrandr runs. The script
    -- looks up the Acer's current connector name instead of hardcoding it.
    hl.exec_cmd("sh -c 'sleep 3; sh ~/.config/hypr/scripts/xwayland-primary.sh'")

    -- Spam-click macro. The daemon installs its own mouse:276 bind and removes it
    -- whenever a game is running. Config: ~/.config/autoclicker.conf
    hl.exec_cmd("python3 ~/.local/bin/autoclickerd")
end)


-- ============================================================
-- DeadSec Theme — Look and Feel
-- ============================================================

hl.config({
    general = {
        border_size      = 1,
        gaps_in          = 4,
        gaps_out         = 8,
        col = {
            active_border   = "rgba(c99a6e99)",
            inactive_border = "rgba(2a252299)",
        },
        resize_on_border = true,
        allow_tearing    = false,
        layout           = "dwindle",
    },

    decoration = {
        rounding = 4,

        active_opacity   = 1.0,
        inactive_opacity = 0.93,

        shadow = {
            enabled        = true,
            range          = 10,
            render_power   = 3,
            color          = "rgba(0000001a)",
            color_inactive = "rgba(00000000)",
        },

        blur = {
            enabled           = true,
            size              = 4,
            passes            = 2,
            new_optimizations = true,
            xray              = false,
        },
    },

    animations = {
        enabled = true,
    },

    dwindle = {
        preserve_split = true,
    },

    misc = {
        force_default_wallpaper  = 0,
        disable_hyprland_logo    = true,
        disable_splash_rendering = true,
    },
})

hl.curve("dedsec", { type = "bezier", points = { {0.05, 0.9}, {0.1, 1.05} } })
hl.curve("linear", { type = "bezier", points = { {0, 0},       {1, 1}     } })
hl.curve("snap",   { type = "bezier", points = { {0.15, 0},    {0.1, 1}   } })

hl.animation({ leaf = "windows",    enabled = true, speed = 4, bezier = "dedsec",  style = "slide" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 3, bezier = "default", style = "slide" })
hl.animation({ leaf = "border",     enabled = true, speed = 8, bezier = "dedsec" })
hl.animation({ leaf = "fade",       enabled = true, speed = 3, bezier = "linear" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 4, bezier = "snap",    style = "slide" })

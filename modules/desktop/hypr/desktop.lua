local fileManager = "cosmic-files"
local mainMod = "SUPER"
local menu = "rofi -show drun"
local shiftMod = mainMod .. " + SHIFT"
local terminal = "alacritty"

local laptopMonitor = "eDP-1"
local homeMonitor = "DP-2"
local workMonitor = "DP-1"

local workspaces = {}
for number = 1, 10 do
	table.insert(workspaces, {
		number = number,
		key = number == 10 and "0" or tostring(number),
		monitor = number <= 3 and laptopMonitor or number <= 6 and homeMonitor or workMonitor,
	})
end

hl.curve("easeOutQuint", {
	type = "bezier",
	points = {
		{ 0.23, 1 },
		{ 0.32, 1 },
	},
})
hl.curve("easeInOutCubic", {
	type = "bezier",
	points = {
		{ 0.65, 0.05 },
		{ 0.36, 1 },
	},
})
hl.curve("linear", {
	type = "bezier",
	points = {
		{ 0, 0 },
		{ 1, 1 },
	},
})
hl.curve("almostLinear", {
	type = "bezier",
	points = {
		{ 0.5, 0.5 },
		{ 0.75, 1.0 },
	},
})
hl.curve("quick", {
	type = "bezier",
	points = {
		{ 0.15, 0 },
		{ 0.1, 1 },
	},
})

local animations = {
	{ leaf = "global", enabled = true, speed = 10, bezier = "default" },
	{ leaf = "border", enabled = true, speed = 5.39, bezier = "easeOutQuint" },
	{ leaf = "windows", enabled = true, speed = 4.79, bezier = "easeOutQuint" },
	{ leaf = "windowsIn", enabled = true, speed = 4.1, bezier = "easeOutQuint", style = "popin 87%" },
	{ leaf = "windowsOut", enabled = true, speed = 1.49, bezier = "linear", style = "popin 87%" },
	{ leaf = "fadeIn", enabled = true, speed = 1.73, bezier = "almostLinear" },
	{ leaf = "fadeOut", enabled = true, speed = 1.46, bezier = "almostLinear" },
	{ leaf = "fade", enabled = true, speed = 3.03, bezier = "quick" },
	{ leaf = "layers", enabled = true, speed = 3.81, bezier = "easeOutQuint" },
	{ leaf = "layersIn", enabled = true, speed = 4, bezier = "easeOutQuint", style = "fade" },
	{ leaf = "layersOut", enabled = true, speed = 1.5, bezier = "linear", style = "fade" },
	{ leaf = "fadeLayersIn", enabled = true, speed = 1.79, bezier = "almostLinear" },
	{ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" },
	{ leaf = "workspaces", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" },
	{ leaf = "workspacesIn", enabled = true, speed = 1.21, bezier = "almostLinear", style = "fade" },
	{ leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" },
}

for _, animation in ipairs(animations) do
	hl.animation(animation)
end

hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind("ALT + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + CTRL + Q", hl.dsp.exec_cmd("loginctl lock-session"))
hl.bind(mainMod .. " + ALT + L", hl.dsp.exec_cmd("loginctl lock-session"))
hl.bind(shiftMod .. " + Q", hl.dsp.exit())
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + M", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + G", hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }))

for _, workspace in ipairs(workspaces) do
	hl.bind(mainMod .. " + " .. workspace.key, hl.dsp.focus({ workspace = workspace.number }))
end

for _, workspace in ipairs(workspaces) do
	hl.bind(mainMod .. " + CTRL + " .. workspace.key, hl.dsp.window.move({ workspace = workspace.number }))
end

hl.bind(mainMod .. " + Left", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mainMod .. " + Right", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(shiftMod .. " + S", hl.dsp.window.move({ workspace = "special:magic" }))
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(shiftMod .. " + 3", hl.dsp.exec_cmd("hyprshot -m output"))
hl.bind(shiftMod .. " + 4", hl.dsp.exec_cmd("hyprshot -m region"))
hl.bind(shiftMod .. " + 5", hl.dsp.exec_cmd("hyprshot -m window"))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + TAB", hl.dsp.window.cycle_next())
hl.bind(shiftMod .. " + Tab", hl.dsp.window.cycle_next({ next = false }))
hl.bind(shiftMod .. " + E", hl.dsp.exec_cmd("wlogout"))
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"), {
	locked = true,
	repeating = true,
})
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), {
	locked = true,
	repeating = true,
})
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), {
	locked = true,
	repeating = true,
})
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), {
	locked = true,
	repeating = true,
})
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl s 10%+"), {
	locked = true,
	repeating = true,
})
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl s 10%-"), {
	locked = true,
	repeating = true,
})
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.config({
	animations = {
		enabled = true,
	},
	decoration = {
		active_opacity = 1.0,
		blur = {
			enabled = true,
			passes = 1,
			size = 3,
			vibrancy = 0.1696,
		},
		inactive_opacity = 1.0,
		rounding = 10,
		shadow = {
			color = "rgba(1a1a1aee)",
			enabled = true,
			range = 4,
			render_power = 3,
		},
	},
	dwindle = {
		preserve_split = true,
	},
	general = {
		allow_tearing = false,
		border_size = 1,
		col = {
			active_border = {
				angle = 45,
				colors = {
					"rgba(33ccffee)",
					"rgba(00ff99ee)",
				},
			},
			inactive_border = "rgba(595959aa)",
		},
		gaps_in = 5,
		gaps_out = 5,
		layout = "dwindle",
		resize_on_border = false,
	},
	input = {
		follow_mouse = 1,
		kb_layout = "us",
		kb_model = "",
		kb_options = "",
		kb_rules = "",
		kb_variant = "",
		natural_scroll = true,
		repeat_delay = 250,
		repeat_rate = 40,
		sensitivity = 0,
		touchpad = {
			natural_scroll = true,
		},
	},
	master = {
		new_status = "master",
	},
	misc = {
		disable_hyprland_logo = true,
		force_default_wallpaper = 0,
	},
})

hl.device({
	name = "epic-mouse-v1",
	sensitivity = -0.5,
})

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("XCURSOR_THEME", "macOS-White")
hl.env("HYPRCURSOR_THEME", "macOS-White")

hl.gesture({
	action = "workspace",
	direction = "horizontal",
	fingers = 3,
})

hl.monitor({
	mode = "1920x1080@60.05",
	output = laptopMonitor,
	position = "0x0",
	scale = 1,
})
hl.monitor({
	mode = "1920x1080@75",
	output = homeMonitor,
	position = "0x-1080",
	scale = 1,
})
hl.monitor({
	mode = "2560x1440@59.95",
	output = workMonitor,
	position = "1920x-360",
	scale = 1,
})

hl.on("hyprland.start", function()
	hl.exec_cmd("gnome-keyring-daemon --start --components=secrets")
	hl.exec_cmd(terminal)
	hl.exec_cmd("waybar")
	hl.exec_cmd("thunderbird")
end)

hl.window_rule({
	match = {
		class = "Alacritty",
	},
	workspace = 1,
})
hl.window_rule({
	match = {
		class = "^thunderbird$",
		initial_title = "^Mozilla Thunderbird$",
	},
	workspace = 2,
})
hl.window_rule({
	center = true,
	float = true,
	match = {
		class = "^thunderbird$",
		initial_title = "^Calendar Reminders$",
	},
	size = "600 400",
	workspace = 2,
})
hl.window_rule({
	match = {
		class = "zen-twilight",
	},
	workspace = 4,
})
hl.window_rule({
	match = {
		class = "dev.zed.Zed",
	},
	workspace = 5,
})
hl.window_rule({
	match = {
		class = "Code",
	},
	workspace = 6,
})
hl.window_rule({
	match = {
		class = ".*",
	},
	suppress_event = "maximize",
})
hl.window_rule({
	match = {
		class = "^$",
		float = true,
		fullscreen = false,
		pin = false,
		title = "^$",
		xwayland = true,
	},
	no_focus = true,
})

for _, workspace in ipairs(workspaces) do
	hl.workspace_rule({
		monitor = workspace.monitor,
		workspace = tostring(workspace.number),
	})
end

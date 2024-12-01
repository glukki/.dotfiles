local SpoonInstall = hs.loadSpoon("SpoonInstall")

SpoonInstall:asyncUpdateAllRepos()

SpoonInstall:andUse("ReloadConfiguration", { start = true })

SpoonInstall:andUse("WindowGrid", {
	config = {gridGeometries = {
		{ "4x4" }
	}},
	hotkeys = { show_grid = { { "ctrl", "alt", "cmd" }, "g" } },
	fn = function()
		hs.grid.setMargins(hs.geometry.point(0, 0))
	end,
	start = true
})

-- open config file
hs.hotkey.bind({ "ctrl", "alt", "cmd" }, "c", function()
	hs.execute("open ~/.hammerspoon/init.lua")
end)

-- switch keyboard layout by Cmd+Ctrl+1/2/3
for idx, layout in pairs(hs.keycodes.layouts()) do
	hs.hotkey.bind({ "ctrl", "cmd" }, tostring(idx), function()
		hs.keycodes.setLayout(layout)
	end)
end

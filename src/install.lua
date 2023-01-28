---
--- Installer script that makes the vein miner autostart
---

-- Path of this script
local cur_path = debug.getinfo(1).source
if path:sub(1,1) == "@" then
	path = path:sub(2)
end
local directory = path:match("(.*/)")

-- Path to the main.lua file
local main_path_name = "main.lua"
local main_path = directory .. main_path_name
print(main_path)

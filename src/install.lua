---
--- Installer script that makes the vein miner autostart
---

-- Path of this script
local cur_path = shell.getRunningProgram()
local cur_dir = fs.getDir(cur_path)

-- Path to the main.lua file
local main_path_name = "main.lua"
local main_path = cur_dir .. main_path_name

print(main_path)

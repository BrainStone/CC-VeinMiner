---
--- Installer script that makes the vein miner autostart
---

-- Path of this script
local cur_path = shell.getRunningProgram()
local cur_dir = fs.getDir(cur_path)
local base_dir = fs.getDir(cur_dir)

-- Path to the main.lua file
local main_path_name = "main.lua"
local main_path = fs.combine(cur_dir, main_path_name)

-- Create startup dir and migrate potentially preexisting startup scripts
if os.exists("startup") then
	if not os.isDir("startup") then
		os.rename("startup", "startup.old.temp")
		os.makeDir("startup")
		os.rename("startup.old.temp", "startup/01-orig_startup")
	end
else
	os.makeDir("startup")
end

-- Write startup file
local h = fs.open("startup/50-vein_miner", "w")

h.writeLine("-- Update repo first")
h.writeLine("shell.run(\"github\", \"clone\", \"BrainStone/CC-VeinMiner\", \"" .. base_dir .. "\")")
h.writeLine("")
h.writeLine("-- Run vein miner")
h.writeLine("shell.run(\"" .. main_path .. "\")")

h.close()

---
--- Installer script that makes the vein miner autostart
---

-- Path of this script
local cur_path = shell.getRunningProgram()
local cur_dir = fs.getDir(cur_path)

-- Path to the cli.lua file
local cli_path_name = "cli.lua"
local cli_path = fs.combine(cur_dir, cli_path_name)
local cli_quoted_path = string.format("%q", cli_path)

-- Create startup dir and migrate potentially preexisting startup scripts
if fs.exists("startup") then
	if not fs.isDir("startup") then
		fs.move("startup", "startup.old.temp")
		fs.makeDir("startup")
		fs.move("startup.old.temp", "startup/01-orig_startup")
	end
else
	fs.makeDir("startup")
end

-- Write startup file
local h = fs.open("startup/50-vein_miner", "w")

h.writeLine("-- Update vein miner first")
h.writeLine("shell.run(" .. cli_quoted_path .. ", \"update\")")
h.writeLine("")
h.writeLine("-- Run vein miner")
h.writeLine("shell.run(" .. cli_quoted_path .. ", \"run\")")

h.close()

-- Write command file
h = fs.open("vein_miner", "w")

h.writeLine("f = loadfile(" .. cli_quoted_path .. ")")
h.writeLine("setfenv(f, getfenv())")
h.writeLine("f(...)")

h.close()

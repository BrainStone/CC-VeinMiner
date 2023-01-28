---
--- Inclusion helper
---
--- Include with this snippet:
--- -- Path of this script
--- local cur_path = shell.getRunningProgram()
--- local cur_dir = fs.getDir(cur_path)
--- -- Include loading helper
--- loadfile(fs.combine(cur_dir, "util/include.lua"), "t", getfenv())()
---

-- Path of this script
cli_path = shell.getRunningProgram()
src_dir = fs.getDir(cli_path)
repo_dir = fs.getDir(src_dir)
lib_dir = fs.combine(src_dir, "lib")

--- Load a library
function loadLib(lib)
	_G[lib] = require("lib." .. lib)
end

--- Run a file
function runFile(file, ...)
	local f = loadfile(fs.combine(src_dir, file))
	setfenv(f, getfenv())
	f(...)
end

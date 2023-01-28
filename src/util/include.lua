---
--- Inclusion helper
---
--- Include with this snippet:
--- -- Path of this script
--- local cur_path = shell.getRunningProgram()
--- local cur_dir = fs.getDir(cur_path)
--- -- Include loading helper
--- dofile(fs.combine(cur_dir, "util/include.lua"))
---

-- Path of this script
local cur_path = shell.getRunningProgram()
local util_dir = fs.getDir(cur_path)
local src_dir = fs.getDir(util_dir)
local lib_dir = fs.combine(src_dir, "lib")
local lib_dir_dots = lib_dir:gsub("/", ".") .. "."

--- Load a library
function loadLib(lib)
	_G[lib] = require(lib_dir_dots .. lib)
end

--- Run a file
function runFile(file, ...)
	local f = loadfile(fs.combine(src_dir, file))
	setfenv(f, getfenv())
	f(...)
end

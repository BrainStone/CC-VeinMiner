---
--- Inclusion helper
---
--- This script is a helper for including other files in a program.
--- It provides the following functions:
--- - `loadLib(lib)`: loads a library from the `lib` directory.
--- - `runFile(file, ...)`: runs a file from the source directory.
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
--- @param lib string the library to load
function loadLib(lib)
	_G[lib] = require("lib." .. lib)
end

--- runFile function runs a given file in the src_dir and pass any additional arguments to the file
--- @param file string the name of the file to run
--- @param ... any any additional arguments to pass to the file
--- @return boolean, any the first value returned by the pcall function is a boolean indicating whether the file ran without error and the rest of the values are the values returned by the file.
function runFile(file, ...)
	local f = loadfile(fs.combine(src_dir, file))
	setfenv(f, getfenv())
	return pcall(f, ...)
end

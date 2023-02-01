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

--- Runs the given file with the given arguments and returns the results.
--- @param file string The name of the file to run
--- @param ... any Any additional arguments to pass to the file when running it
--- @return boolean Whether or not the file ran successfully
--- @return any The return values of the file, if it ran successfully
--- @return string The traceback of any error that occurred, if the file did not run successfully
function runFile(file, ...)
	-- Load file as a function and set up the env
	local file_path = fs.combine(src_dir, file)
	local file_func, err = loadfile(file_path)

	if file_func == nil then
		return false, debug.traceback(), "Could not load file " .. file_path .. ": " .. err
	end

	local args = table.pack(...)
	setfenv(file_func, getfenv())

	-- Capture the traceback in case of error
	local traceback

	-- Run the file function with xpcall, capturing any errors and the traceback
	local call_result = table.pack(xpcall(
		function()
			file_func(table.unpack(args))
		end,
		function(err)
			traceback = debug.traceback()

			return err
		end
	))

	-- Unpack the call result if successful, otherwise return error and traceback
	if call_result[1] then
		return table.unpack(call_result)
	else
		return call_result[1], traceback, call_result[2]
	end
end


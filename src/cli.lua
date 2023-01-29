---
--- Helper program that parses command line parameters and calls the corresponding programs
---

-- Path of this script
local cur_path = shell.getRunningProgram()
local cur_dir = fs.getDir(cur_path)
-- Include loading helper
loadfile(fs.combine(cur_dir, "util/include.lua"), "t", getfenv())()

-- Load settings
local settings_file = fs.combine(repo_dir, ".settings")
settings.load(settings_file)

-- Parse parameters
local selectedAction = arg[1]

local subcommands = {
	__tabcomplete = {
		usage = "vein_miner __tabcomplete"
	},
	update = {
		usage = "vein_miner update"
	},
	run = {
		usage = "vein_miner run"
	}
}

local action = subcommands[selectedAction]
if not action then
	for _, v in pairs(subcommands) do
		print(v.usage)
		print(" ")
	end
	return
end

-- Provide cleanup functions
local cleanup_functions = {}

--- Register a function to be called when the program exits
--- @param cleanup_function function to be called on program exit. It gets passed a boolean that indicates if the program exited successfully.
function registerCleanup(cleanup_function)
	if type(cleanup_function) ~= "function" then
		error("cleanup_function must be a function , got " .. type(cleanup_function))
	end

	-- Insert the provided function into the array of cleanup functions
	table.insert(cleanup_functions, cleanup_function)
end

-- Execute program
local success = true
local error_message

if action == subcommands.__tabcomplete then
	-- Hiding __tabcomplete
	local visible_subcommands = {}
	for subcommand in pairs(subcommands) do
		if subcommand ~= "__tabcomplete" then
			table.insert(visible_subcommands, subcommand)
		end
	end

	-- Command line completion
	local completion = require "cc.shell.completion"
	local complete = completion.build(
		{ completion.choice, visible_subcommands }
	)

	-- Set tabcomplete for both files
	shell.setCompletionFunction(cur_path, complete)
elseif action == subcommands.update then
	-- Update logic
	-- Expects the 3rd parameter to be the path
	success, error_message = runFile("update.lua", "", "", repo_dir)
elseif action == subcommands.run then
	-- Just call the main
	success, error_message = runFile("main.lua")
end

-- Execute cleanup
for _, cleanup_function in ipairs(cleanup_functions) do
	cleanup_function(success)
end

-- Save settings
settings.save(settings_file)

-- Rethrow errors. We're catching them in the first place so we can guarantee that cleanup is called
if not success then
	error(error_message)
end

---
--- Helper program that parses command line parameters and calls the corresponding programs
---

-- Path of this script
local cur_path = shell.getRunningProgram()
local cur_dir = fs.getDir(cur_path)
-- Include loading helper
loadfile(fs.combine(cur_dir, "util/include.lua"), "t", getfenv())()

-- Parse parameters
local selectedAction = select(1, ...)

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
	shell.setCompletionFunction("vein_miner", complete)
	shell.setCompletionFunction(cur_path, complete)
elseif action == subcommands.update then
	-- Update logic
elseif action == subcommands.run then
	-- Just call
	runFile("main.lua")
end


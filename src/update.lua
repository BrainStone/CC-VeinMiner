---
--- Update the repo
---
--- This file needs to be self contained because it's expected to be run via
--- wget run https://raw.githubusercontent.com/BrainStone/CC-VeinMiner/master/src/update.lua
---

-- Determine target_path (first two args are run and the URL)
local target_path = arg[3] or "vein_miner"

-- Check if github is installed and if not install it
if shell.resolveProgram("github") == nil then
	if not shell.execute("pastebin", "run", "p8PJVxC4") then
		error()
	end
end

-- Download repo
if not shell.execute("github", "clone", "BrainStone/CC-VeinMiner", target_path) then
	error()
end

-- Execute install script
if not shell.execute(fs.combine(target_path, "src/install.lua")) then
	error()
end

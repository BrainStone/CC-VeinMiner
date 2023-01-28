---
--- Update the repo
---
--- This file needs to be self contained because it's expected to be run via
--- wget run https://raw.githubusercontent.com/BrainStone/CC-VeinMiner/master/src/update.lua
---

-- Determine target_path
local target_path = arg[1] or "vein_miner"

-- Check if github is installed and if not install it
if shell.resolveProgram("github") == nil then
	local h = io.popen("pastebin run p8PJVxC4", "r")
	h:close()
end

-- Download repo
shell.run("github", "clone", "BrainStone/CC-VeinMiner", target_path)

-- Execute install script
shell.run(fs.combine(target_path, "src/install.lua"))

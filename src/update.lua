---
--- Update the repo
---
--- This file needs to be self contained because it's expected to be run via
--- wget run https://raw.githubusercontent.com/BrainStone/CC-VeinMiner/master/src/update.lua
---

-- Determine target_path
local target_path = arg[1] or "vein_miner"
print("Target path " .. target_path)

-- Check if github is installed and if not install it
if shell.resolveProgram("github") == nil then
	shell.execute("pastebin", "run", "p8PJVxC4")
end

-- Download repo
shell.execute("github", "clone", "BrainStone/CC-VeinMiner", target_path)

-- Execute install script
shell.execute(fs.combine(target_path, "src/install.lua"))

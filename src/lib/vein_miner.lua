---
--- Library to help mining veins
---

loadLib("coordinate")
loadLib("movement")
loadLib("block_list")

-- Register settings used in this module
local setting_base = "vein_miner.vein_miner."
-- TODO: Define settings here

-- State variables
local cant_break_list = {
	"minecraft:bedrock",
}
local trash_list = {
	"#minecraft:base_stone_overworld",
	"#minecraft:base_stone_nether",
	"#minecraft:dirt",
	"#minecraft:sand",
	"#minecraft:terracotta",
	"#minecraft:ice",
	"#minecraft:snow",
	"#forge:sandstone",
	"#forge:gravel",
	"#forge:end_stones",
	"#forge:cobblestone",
	"minecraft:calcite",
	"minecraft:water",
	"minecraft:lava",
}
local valuable_list = {
	"#minecraft:diamond_ores",
	"#minecraft:emerald_ores",
	"#minecraft:redstone_ores",
	"minecraft:ancient_debris",
}

-- Save config on exit
--- Saves the current position of the turtle.
--- The position is saved as a set of x, y, z coordinates and a facing value.
local function saveVeinMinerData()
	-- TODO: Save data here
end

registerCleanup(saveVeinMinerData)

-- Register lists
block_list.registerList("cant_break", cant_break_list)
block_list.registerList("trash", trash_list)
block_list.registerList("valuable", valuable_list)

-- Exports
return {
	-- Variables
	cant_break_list = cant_break_list,
	trash_list = trash_list,
	valuable_list = valuable_list

	-- Functions
}

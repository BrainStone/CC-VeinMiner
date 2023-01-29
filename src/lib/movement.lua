---
--- Library to make moving around easier
---

loadLib("coordinate")

-- Register settings used in this module
local setting_base = "vein_miner.movement."
settings.define(setting_base .. "current_postion.coordinate.x", { default = 0, type = "number" })
settings.define(setting_base .. "current_postion.coordinate.y", { default = 0, type = "number" })
settings.define(setting_base .. "current_postion.coordinate.z", { default = 0, type = "number" })
settings.define(setting_base .. "current_postion.facing", { default = 0, type = "number" })

-- State variables
local home_position = {
	coordinate = coordinate:new(0, 0, 0),
	facing = 0,
}
local current_position = {
	coordinate = coordinate:new(
		settings.get(setting_base .. "current_postion.coordinate.x"),
		settings.get(setting_base .. "current_postion.coordinate.y"),
		settings.get(setting_base .. "current_postion.coordinate.z")
	),
	facing = settings.get(setting_base .. "current_postion.facing"),
}

-- Save config on exit
local function saveCurrentPosition()
	settings.set(setting_base .. "current_postion.coordinate.x", current_position.coordinate.x)
	settings.set(setting_base .. "current_postion.coordinate.y", current_position.coordinate.y)
	settings.set(setting_base .. "current_postion.coordinate.z", current_position.coordinate.z)
	settings.set(setting_base .. "current_postion.facing", current_position.facing)
end

registerCleanup(saveCurrentPosition)

-- Movement function
--- Rotate the turtle left by a given count
--- @param count number of times to rotate left, defaults to 1
local function turnLeft(count)
	-- if count is not a number, default to 1
	if type(count) ~= "number" then
		count = 1
	end

	-- rotate the turtle left by the count specified
	for _ = 1, count do
		turtle.turnLeft()
	end

	-- update the current facing of the turtle
	current_position.facing = (current_position.facing - count) % 4
end

--- Rotate the turtle right by a given count
--- @param count number of times to rotate right, defaults to 1
local function turnRight(count)
	-- if count is not a number, default to 1
	if type(count) ~= "number" then
		count = 1
	end

	-- rotate the turtle right by the count specified
	for _ = 1, count do
		turtle.turnRight()
	end

	-- update the current facing of the turtle
	current_position.facing = (current_position.facing + count) % 4
end

--- Rotate the turtle to a specified facing
--- @param target_facing number the desired facing for the turtle, must be a number between 0 and 3
local function turnToFacing(target_facing)
	-- if target_facing is not a number or is out of bounds, return
	if type(target_facing) ~= "number" or target_facing < 0 or target_facing >= 4 then
		error("target_facing must be a number between 0 and 3, got " .. tostring(target_facing))
	end

	-- calculate the number of rotations needed to reach the target facing
	-- by subtracting the current facing from the target facing and taking the remainder
	-- with 4. This allows the calculation to wrap around if the target facing is
	-- less than the current facing.
	local rotation = (target_facing - current_position.facing) % 4

	-- if rotation is 1, turn right once
	if rotation == 1 then
		turnRight()
		-- if rotation is 2, turn right twice
	elseif rotation == 2 then
		turnRight(2)
		-- if rotation is 3, turn left once
	elseif rotation == 3 then
		turnLeft()
	end
end

-- Exports
return {
	-- Variables
	home_position = home_position,
	current_position = current_position,

	-- Functions
	turnLeft = turnLeft,
	turnRight = turnRight,
	turnToFacing = turnToFacing,
}

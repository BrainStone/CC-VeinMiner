---
--- Library to make moving around easier
---

local coordinate = require("lib.coordinate")

-- Register settings used in this module
local setting_base = "vein_miner.movement."
coordinate:defineSetting(setting_base .. "current_position.coordinate")
settings.define(setting_base .. "current_position.facing", { default = 0, type = "number" })

-- State variables
local home_position = {
	coordinate = coordinate:new(0, 0, 0),
	facing = 0,
}
local start_position = {
	coordinate = coordinate:new(2, 0, 0),
	facing = 0,
}
local current_position = {
	coordinate = coordinate:fromSetting(setting_base .. "current_position.coordinate"),
	facing = settings.get(setting_base .. "current_position.facing"),
}

-- Save config on exit
--- Saves the current position of the turtle.
--- The position is saved as a set of x, y, z coordinates and a facing value.
local function saveCurrentPosition()
	current_position.coordinate:toSetting(setting_base .. "current_position.coordinate")
	settings.set(setting_base .. "current_position.facing", current_position.facing)
end

registerCleanup(saveCurrentPosition)

-- Helper functions
local advanceCurrentPositionInFacing
-- Simple movement functions
local turnLeft, turnRight, moveForward, moveBackward, moveUpward, moveDownward
-- Smart movement functions
local moveInX, moveInY, moveInZ
-- Complex movement functions
local turnToFacing, moveToRelative, moveToPosition, moveHome

-- Helper functions
--- Advances the current position of the turtle based on the facing
--- @param n number The distance to advance the turtle in the direction it is facing
function advanceCurrentPositionInFacing(n)
	-- update the current position of the turtle based on the facing
	if current_position.facing == 0 then
		current_position.coordinate.x = current_position.coordinate.x + n
	elseif current_position.facing == 1 then
		current_position.coordinate.z = current_position.coordinate.z + n
	elseif current_position.facing == 2 then
		current_position.coordinate.x = current_position.coordinate.x - n
	elseif current_position.facing == 3 then
		current_position.coordinate.z = current_position.coordinate.z - n
	end
end


-- Simple movement functions
--- Rotate the turtle left by a given count
--- @param count number of times to rotate left, defaults to 1
function turnLeft(count)
	-- if count is not a number (or not given), default to 1
	if type(count) ~= "number" then
		count = 1
	elseif count < 0 then
		return turnRight(-count)
	end

	-- rotate the turtle left by the count specified
	for _ = 1, count do
		-- update the current facing of the turtle
		current_position.facing = (current_position.facing - 1) % 4

		turtle.turnLeft()
	end
end

--- Rotate the turtle right by a given count
--- @param count number of times to rotate right, defaults to 1
function turnRight(count)
	-- if count is not a number (or not given), default to 1
	if type(count) ~= "number" then
		count = 1
	elseif count < 0 then
		return turnLeft(-count)
	end

	-- rotate the turtle right by the count specified
	for _ = 1, count do
		-- update the current facing of the turtle
		current_position.facing = (current_position.facing + 1) % 4

		turtle.turnRight()
	end
end

--- Move the turtle forward by a given count
--- @param count number of blocks to move forward, defaults to 1
function moveForward(count)
	-- if count is not a number (or not given), default to 1
	if type(count) ~= "number" then
		count = 1
	elseif count < 0 then
		return moveBackward(-count)
	end

	-- move the turtle forward by the count specified
	for _ = 1, count do
		while true do
			-- update the current position of the turtle
			advanceCurrentPositionInFacing(1)

			if turtle.forward() then
				break
			end

			-- undo the change if it couldn't move
			advanceCurrentPositionInFacing(-1)

			turtle.dig()
		end
	end
end

--- Move the turtle backward by a given count
--- @param count number of blocks to move backwards, defaults to 1
function moveBackward(count)
	-- if count is not a number (or not given), default to 1
	if type(count) ~= "number" then
		count = 1
	elseif count < 0 then
		return moveForward(-count)
	end

	-- move the turtle backward by the count specified
	for _ = 1, count do
		while true do
			-- update the current position of the turtle
			advanceCurrentPositionInFacing(-1)

			if turtle.back() then
				break
			end

			-- undo the change if it couldn't move
			advanceCurrentPositionInFacing(1)

			-- Dig backwards
			turnRight(2)
			turtle.dig()
			turnRight(2)
		end
	end
end

--- Move the turtle upward by a given count
--- @param count number of blocks to move upward, defaults to 1
function moveUpward(count)
	-- if count is not a number (or not given), default to 1
	if type(count) ~= "number" then
		count = 1
	elseif count < 0 then
		return moveDownward(-count)
	end

	-- move the turtle upward by the count specified
	for _ = 1, count do
		while true do
			-- update the current position of the turtle
			current_position.coordinate.y = current_position.coordinate.y + 1

			if turtle.up() then
				break
			end

			-- undo the change if it couldn't move
			current_position.coordinate.y = current_position.coordinate.y - 1

			turtle.digUp()
		end
	end
end

--- Move the turtle downward by a given count
--- @param count number of blocks to move downward, defaults to 1
function moveDownward(count)
	-- if count is not a number (or not given), default to 1
	if type(count) ~= "number" then
		count = 1
	elseif count < 0 then
		return moveUpward(-count)
	end

	-- move the turtle downward by the count specified
	for _ = 1, count do
		while true do
			-- update the current position of the turtle
			current_position.coordinate.y = current_position.coordinate.y - 1

			if turtle.down() then
				break
			end

			-- undo the change if it couldn't move
			current_position.coordinate.y = current_position.coordinate.y + 1

			turtle.digDown()
		end
	end
end

-- Smart movement functions
--- Move the turtle in X direction
--- @param count number of blocks to move in x direction. Supports both positive and negative numbers
function moveInX(count)
	-- if count is not a number, error
	if type(count) ~= "number" then
		error("count must be a number, got " .. tostring(count))
	end

	if count > 0 then
		turnToFacing(0)
		moveForward(count)
	elseif count < 0 then
		turnToFacing(2)
		moveForward(-count)
	end
end

--- Move the turtle in Y direction
--- @param count number of blocks to move in y direction. Supports both positive and negative numbers
function moveInY(count)
	-- if count is not a number, error
	if type(count) ~= "number" then
		error("count must be a number, got " .. tostring(count))
	end

	if count > 0 then
		moveUpward(count)
	elseif count < 0 then
		moveDownward(-count)
	end
end

--- Move the turtle in Z direction
--- @param count number of blocks to move in z direction. Supports both positive and negative numbers
function moveInZ(count)
	-- if count is not a number, error
	if type(count) ~= "number" then
		error("count must be a number, got " .. tostring(count))
	end

	if count > 0 then
		turnToFacing(1)
		moveForward(count)
	elseif count < 0 then
		turnToFacing(3)
		moveForward(-count)
	end
end

-- Complex movement functions
--- Rotate the turtle to a specified facing
--- @param target_facing number the desired facing for the turtle, must be a number between 0 and 3
function turnToFacing(target_facing)
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

--- Moves the turtle to the relative target position, and optionally changes the facing
--- @param target_position table The relative target position as a Coordinate
--- @param target_facing number Optional parameter for the facing to change to
function moveToRelative(target_position, target_facing)
	local dx = target_position.x
	local dy = target_position.y
	local dz = target_position.z

	-- First get to the correct height...
	moveInY(dy)

	-- ...then to the correct cardinal position with the optimal amount of turns
	local first_axis

	-- Determine optimal cardinal direction to move in first
	if dx == 0 or dz == 0 then
		-- Only one cardinal direction, so only one of these functions will do something, either would work
		first_axis = "x"
	elseif current_position.facing == 0 then
		if dx > 0 then
			first_axis = "x"
		else
			first_axis = "z"
		end
	elseif current_position.facing == 1 then
		if dz > 0 then
			first_axis = "z"
		else
			first_axis = "x"
		end
	elseif current_position.facing == 2 then
		if dx > 0 then
			first_axis = "z"
		else
			first_axis = "x"
		end
	elseif current_position.facing == 3 then
		if dz > 0 then
			first_axis = "x"
		else
			first_axis = "z"
		end
	end

	-- Move turtle to the target position
	if first_axis == "x" then
		moveInX(dx)
		moveInZ(dz)
	elseif first_axis == "z" then
		moveInZ(dz)
		moveInX(dx)
	end

	if target_facing ~= nil then
		turnToFacing(target_facing)
	end
end

--- Moves the turtle to the target position, and optionally changes the facing
--- @param target_position table The target position as a Coordinate
--- @param target_facing number Optional parameter for the facing to change to
function moveToPosition(target_position, target_facing)
	-- `-coord1 + coord2` is correct because the `-` operator calculates distance
	return moveToRelative(-current_position.coordinate + target_position, target_facing)
end

--- First moves the turtle to the start position and then to the home position. This is to to protect the station
function moveHome()
	-- Check if turtle is at or near the station
	if current_position.coordinate.x < 0 and (current_position.coordinate.z >= -2 and current_position.coordinate.z <= 2) then
		-- Move turtle away from station along the z-axis
		local target_z = current_position.coordinate.z < 0 and 3 or -3
		moveToRelative(coordinate:new(0, 0, target_z - current_position.coordinate.z))
	end

	-- Move to position properly
	if
	(
		current_position.coordinate.x < home_position.coordinate.x or
			current_position.coordinate.x >= start_position.coordinate.x
	) or
		current_position.coordinate.y ~= 0 or
		current_position.coordinate.z ~= 0 then
		-- If we're at home or in between home and start position, don't go to the start position
		moveToPosition(start_position.coordinate)
	end
	moveToPosition(home_position.coordinate, home_position.facing)
end


-- Exports
return {
	-- Variables
	home_position = home_position,
	start_position = start_position,
	current_position = current_position,

	-- Functions
	turnLeft = turnLeft,
	turnRight = turnRight,
	moveForward = moveForward,
	moveBackward = moveBackward,
	moveUpward = moveUpward,
	moveDownward = moveDownward,

	moveInX = moveInX,
	moveInY = moveInY,
	moveInZ = moveInZ,

	turnToFacing = turnToFacing,
	moveToRelative = moveToRelative,
	moveToPosition = moveToPosition,
	moveHome = moveHome,
}

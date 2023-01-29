---
--- Library to make moving around easier
---

loadLib("coordinate")

-- Register settings used in this module
local setting_base = "vein_miner.movement."
coordinate:defineSetting(setting_base .. "current_position.coordinate")
settings.define(setting_base .. "current_position.facing", { default = 0, type = "number" })

-- State variables
local home_position = {
	coordinate = coordinate:new(0, 0, 0),
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
	current_position.coordinate.toSetting(setting_base .. "current_position.coordinate")
	settings.set(setting_base .. "current_position.facing", current_position.facing)
end

registerCleanup(saveCurrentPosition)

-- Simple movement functions
local turnLeft, turnRight, moveForward, moveBackward, moveUpward, moveDownward
-- Smart movement functions
local moveInX, moveInY, moveInZ
-- Complex movement functions
local turnToFacing, moveToPosition, moveHome

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
		turtle.turnLeft()
	end

	-- update the current facing of the turtle
	current_position.facing = (current_position.facing - count) % 4
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
		turtle.turnRight()
	end

	-- update the current facing of the turtle
	current_position.facing = (current_position.facing + count) % 4
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
		while not turtle.forward() do
			turtle.dig()
		end
	end

	-- update the current position of the turtle
	if current_position.facing == 0 then
		current_position.coordinate.x = current_position.coordinate.x + count
	elseif current_position.facing == 1 then
		current_position.coordinate.z = current_position.coordinate.z + count
	elseif current_position.facing == 2 then
		current_position.coordinate.x = current_position.coordinate.x - count
	elseif current_position.facing == 3 then
		current_position.coordinate.z = current_position.coordinate.z - count
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
		while not turtle.back() do
			turnRight(2)
			turtle.dig()
			turnRight(2)
		end
	end

	-- update the current position of the turtle
	if current_position.facing == 0 then
		current_position.coordinate.x = current_position.coordinate.x - count
	elseif current_position.facing == 1 then
		current_position.coordinate.z = current_position.coordinate.z - count
	elseif current_position.facing == 2 then
		current_position.coordinate.z = current_position.coordinate.x + count
	elseif current_position.facing == 3 then
		current_position.coordinate.z = current_position.coordinate.z + count
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
		while not turtle.up() do
			turtle.digUp()
		end
	end

	-- update the current position of the turtle
	current_position.coordinate.y = current_position.coordinate.y + count
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
		while not turtle.down() do
			turtle.digDown()
		end
	end

	-- update the current position of the turtle
	current_position.coordinate.y = current_position.coordinate.y - count
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

--- Moves the turtle to the target position, and optionally changes the facing
--- @param target_position table The target position as a Coordinate
--- @param target_facing number Optional parameter for the facing to change to
function moveToPosition(target_position, target_facing)
	local dx = target_position.x - current_position.coordinate.x
	local dy = target_position.y - current_position.coordinate.y
	local dz = target_position.z - current_position.coordinate.z

	-- First get to the correct height, then the correct z position and then the correct x position
	-- This ensures it returns home safely
	moveInY(dy)
	moveInZ(dz)
	moveInX(dx)

	if target_facing ~= nil then
		turnToFacing(target_facing)
	end
end

--- Moves the turtle to the home position, as defined by the global home_position variable
function moveHome()
	moveToPosition(home_position.coordinate, home_position.facing)
end


-- Exports
return {
	-- Variables
	home_position = home_position,
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
	moveToPosition = moveToPosition,
	moveHome = moveHome,
}

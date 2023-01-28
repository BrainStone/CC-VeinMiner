---
--- Coordinate class to simplify working with coordinates
---

--- Coordinate class
-- @field x x coordinate
-- @field y y coordinate
-- @field z z coordinate
Coordinate = {}
Coordinate.__index = Coordinate

--- Creates a new Coordinate object
-- @param x x coordinate
-- @param y y coordinate
-- @param z z coordinate
-- @return a new Coordinate object
function Coordinate:new(x, y, z)
	local coord = {}
	setmetatable(coord, self)
	coord.x = x
	coord.y = y
	coord.z = z
	return coord
end

--- Calculates the manhattan distance between two coordinates
-- @param x x coordinate of the other point or a Coordinate object
-- @param y y coordinate of the other point or nil if x is a Coordinate object
-- @param z z coordinate of the other point or nil if x is a Coordinate object
-- @return distance as a number
function Coordinate:distance(x, y, z)
	if type(x) == "table" and x.x and x.y and x.z then
		return self:distance(x.x, x.y, x.z)
	elseif type(x) == "number" and type(y) == "number" and type(z) == "number" then
		return math.abs(self.x - x) + math.abs(self.y - y) + math.abs(self.z - z)
	else
		error("Invalid argument, expected a Coordinate object or 3 integers")
	end
end

--- Returns a new Coordinate object with the offset applied
-- @param dx x offset
-- @param dy y offset
-- @param dz z offset
-- @param or offset which can be a number or a Coordinate object
-- @return new Coordinate object
function Coordinate:offset(dx, dy, dz)
	if type(dx) == "table" and dx.x and dx.y and dx.z then
		return self:offset(dx.x, dx.y, dx.z)
	elseif type(dx) == "number" then
		if not dy and not dz then
			dy = dx
			dz = dx
		end

		return self:new(self.x + dx, self.y + dy, self.z + dz)
	else
		error("Invalid argument, expected a number or a Coordinate object")
	end
end

--- Overloads the + operator for Coordinate objects
-- @param other Coordinate object or a number to add
-- @return new Coordinate object
function Coordinate:__add(other)
	return self:offset(other)
end

--- Overloads the - operator for Coordinate objects
-- @param other Coordinate object to subtract
-- @return distance as a number
function Coordinate:__sub(other)
	return self:distance(other)
end

-- Return the class itself
return Coordinate

---
--- Coordinate class to simplify working with coordinates
---

--- Coordinate class
--- @field x number x coordinate
--- @field y number y coordinate
--- @field z number z coordinate
Coordinate = {}
Coordinate.__index = Coordinate

--- Creates a new Coordinate object
--- @param x number x coordinate
--- @param y number y coordinate
--- @param z number z coordinate
--- @return table a new Coordinate object
function Coordinate:new(x, y, z)
	local coord = {}
	setmetatable(coord, self)
	coord.x = x
	coord.y = y
	coord.z = z
	return coord
end

--- Define Coordinate's settings
--- @param setting_basename string The base name of the settings
function Coordinate:defineSetting(setting_basename)
	settings.define(setting_basename .. ".x", { default = 0, type = "number" })
	settings.define(setting_basename .. ".y", { default = 0, type = "number" })
	settings.define(setting_basename .. ".z", { default = 0, type = "number" })
end

--- Create a new Coordinate object from setting
--- @param setting_basename string The base name of the settings
--- @return table a new Coordinate object
function Coordinate:fromSetting(setting_basename)
	return Coordinate:new(
		settings.get(setting_basename .. ".x"),
		settings.get(setting_basename .. ".y"),
		settings.get(setting_basename .. ".z")
	)
end

--- Save the Coordinate object to setting
--- @param setting_basename string The base name of the settings
function Coordinate:toSetting(setting_basename)
	settings.set(setting_basename .. ".x", self.x)
	settings.set(setting_basename .. ".y", self.y)
	settings.set(setting_basename .. ".z", self.z)
end

--- Calculates the manhattan distance between two coordinates
--- @param x number|number|table x coordinate of the other point or a Coordinate object
--- @param y number|nil|nil y coordinate of the other point or nil if x is a Coordinate object
--- @param z number|nil|nil z coordinate of the other point or nil if x is a Coordinate object
--- @return number distance as a number
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
--- @param dx number|table x offset or a Coordinate object
--- @param dy number|nil y offset
--- @param dz number|nil z offset
--- @return table new Coordinate object
function Coordinate:offset(dx, dy, dz)
	if type(dx) == "table" and dx.x and dx.y and dx.z then
		return self:offset(dx.x, dx.y, dx.z)
	elseif type(dx) == "number" then
		if not dy and not dz then
			dy = dx
			dz = dx
		end

		return Coordinate:new(self.x + dx, self.y + dy, self.z + dz)
	else
		error("Invalid argument, expected a number or a Coordinate object")
	end
end

--- Overrides the - operator for Coordinate objects.
--- This allows for inverting the x, y, and z values of a Coordinate object.
--- @return table A new Coordinate object with inverted x, y, and z values
function Coordinate:__unm()
	return Coordinate:new(-self.x, -self.y, -self.z)
end

--- Overloads the + operator for Coordinate objects
--- @param other number|table Coordinate object or a number to add
--- @return table new Coordinate object
function Coordinate:__add(other)
	return self:offset(other)
end

--- Overloads the - operator for Coordinate objects
--- @param other table Coordinate object to subtract
--- @return number distance as a number
function Coordinate:__sub(other)
	return self:distance(other)
end

--- Compares two Coordinate objects for equality
--- @param other table the other Coordinate object to compare
--- @return boolean true if the two Coordinate objects are equal, false otherwise
function Coordinate:__eq(other)
	if type(other) ~= "table" or not other.x or not other.y or not other.z then
		error("Invalid argument, expected a Coordinate object")
	end

	return self.x == other.x and self.y == other.y and self.z == other.z
end

--- Compares two Coordinate objects for inequality
--- @param other table the other Coordinate object to compare
--- @return boolean true if the two Coordinate objects are not equal, false otherwise
function Coordinate:__ne(other)
	return not self:__eq(other)
end

-- Return the class itself
return Coordinate

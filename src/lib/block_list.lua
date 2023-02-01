---
--- Library to help sorting blocks into lists
---

-- State variables
local default_list = "unknown"
local registered_lists = {}
local block_cache = {}

-- Functions
--- Register a list of blocks by their names
--- @param name string the name of the list
--- @param list table a table of block names
local function registerList(name, list)
	local filtered_list = {}

	-- Filter the list for blocks that start with '#' and store in filtered_list
	for _, block in ipairs(list) do
		if string.sub(block, 1, 1) == "#" then
			filtered_list[#filtered_list + 1] = string.sub(block, 2)
		else
			block_cache[block] = name
		end
	end

	-- Store the filtered list in the registered_lists table
	registered_lists[name] = filtered_list
end

--- Determine the list to which a block belongs
--- @param inspect_result table the data of the block as returned by turtle.inspect()
--- @return string the name of the list the block belongs to
local function determineList(inspect_result)
	-- Lookup the block in the cache
	local block_name = inspect_result.name
	local res = block_cache[block_name]

	-- If the block is found in the cache, return the result
	if res ~= nil then
		return res
	end

	-- Initialize the list to the default_list
	local list = default_list

	-- Loop through registered_lists to find the list to which the block belongs
	for name, tags in pairs(registered_lists) do
		for _, tag in pairs(tags) do
			if inspect_result.tags[tag] then
				list = name

				break
			end
		end

		-- We found a list, end the loop
		if list ~= default_list then
			break
		end
	end

	-- Cache the result
	block_cache[block_name] = list

	-- Return the result
	return list
end

--- Determine the block in front of the turtle
--- @return string|nil the name of the list the block belongs to, or nil if no block is found
local function determineBlock()
	-- Inspect the block in front of the turtle
	local found, data = turtle.inspect()

	-- If a block is found, determine its list
	if found then
		return determineList(data)
	else
		return nil
	end
end

--- Determine the block above the turtle
--- @return string|nil the name of the list the block belongs to, or nil if no block is found
local function determineBlockUp()
	-- Inspect the block above the turtle
	local found, data = turtle.inspectUp()

	-- If a block is found, determine its list
	if found then
		return determineList(data)
	else
		return nil
	end
end

--- Determine the block below the turtle
--- @return string|nil the name of the list the block belongs to, or nil if no block is found
local function determineBlockDown()
	-- Inspect the block below the turtle
	local found, data = turtle.inspectDown()

	-- If a block is found, determine its list
	if found then
		return determineList(data)
	else
		return nil
	end
end

-- Exports
return {
	-- Variables
	default_list = default_list,

	-- Functions
	registerList = registerList,
	determineList = determineList,
	determineBlock = determineBlock,
	determineBlockUp = determineBlockUp,
	determineBlockDown = determineBlockDown,
}

---
--- Library to help sorting blocks into lists
---

-- State variables
local default_list = "unknown"
local registered_lists = {}
local block_cache = {}

-- Functions
local function registerList(name, list)
	local filtered_list = {}

	for _, block in ipairs(list) do
		if string.sub(block, 1, 1) == "#" then
			filtered_list[#filtered_list + 1] = string.sub(block, 2)
		else
			block_cache[block] = name
		end
	end

	registered_lists[name] = filtered_list
end

local function determineList(inspect_result)
	-- Lookup the block in the cache
	local block_name = inspect_result.name
	local res = block_cache[block_name]

	if res ~= nil then
		return res
	end

	-- Find block in the lists
	local list = default_list

	for name, tags in ipairs(registered_lists) do
		for _, tag in ipairs(tags) do
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

local function determineBlock()
	return determineList(turtle.inspect())
end

local function determineBlockUp()
	return determineList(turtle.inspectUp())
end

local function determineBlockDown()
	return determineList(turtle.inspectDown())
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

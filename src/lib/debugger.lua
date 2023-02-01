---
--- Helper library to debug objects
---

local debug_file_name = "debug_vein_miner.txt"

-- Wipe the file
-- This will only happen once because requires caches all files and therefore only calls this code once, no matter how
-- many times it gets required
fs.open(debug_file_name, "w").close()

-- Functions
--- Writes the string representation of the passed objects to a file.
---
--- The line number the function was called from and the source file it was called from is written first.
--- The string representation of each passed object is written on a separate line.
--- If serialization of an object fails, it is directly converted to a string and written to the file.
--- @param ... any The objects to be written to the file
local function inspectObject(...)
	-- Open file for appending the string representation of
	local h = fs.open(debug_file_name, "a")

	-- Write source info
	local source = debug.getinfo(2, "Sl")
	h.writeLine("Debug call at " .. source.short_src .. ":" .. source.currentline .. ":")

	-- Write objects
	local params = { ... }
	local success, data
	for _, obj in pairs(params) do
		success, data = pcall(textutils.serialize, obj)

		if success then
			h.writeLine(data)
		else
			h.writeLine("~ Error while trying to serialize. Converting to string directly ~")
			h.writeLine(tostring(obj))
		end
	end

	-- Save contents
	h.close()
end

-- Exports
return {
	-- Variables

	-- Functions
	inspectObject = inspectObject,
}

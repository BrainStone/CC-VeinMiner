---
--- Helper library to debug objects
---

local debug_file_name = "debug_vein_miner.txt"

-- Wipe the file
fs.open(debug_file_name, "w").close()

-- Functions
local function inspectObject(object, ...)
    -- Open file for appending the string reprentation of
    local h = fs.open(debug_file_name, "a")

    -- Write source info
    local source = debug.getinfo(2)
    h.writeLine(source.source .. ":" .. source.linedefined)

    -- Write objects
    local params = { ... }
    for _, obj in pairs(params) do
        h.writeLine(textutils.serialise(obj))
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

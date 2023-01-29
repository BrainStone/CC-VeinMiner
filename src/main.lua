---
--- Main script of the vein miner
---

loadLib("coordinate")
loadLib("movement")

--- Returns a pair of coordinates that follow an ever expanding pattern
--- @param n number The number to find the coordinates for
--- @return table The coordinate for the given number
function spiral_coordinates(n)
	local level = math.floor((1 + math.sqrt(4 * n + 1)) / 4)
	local level2 = level * 2
	local level_offset = n - (level2 * level2 - level2)
	local direction = ((level % 2) * 2) - 1

	local x, z

	-- Check which part of the spiral the current number is in based on the level offset
	if level_offset < level2 then
		x = level_offset
		z = level2 * direction
	elseif level_offset < (level2 * 3) then
		x = level2
		z = ((level2 * 2) - level_offset) * direction
	elseif level_offset < (level2 * 4) then
		x = (level2 * 4) - level_offset
		z = -level2 * direction
	else
		x = 0
		z = (level_offset - (level2 * 3)) * direction * -1
	end

	return coordinate:new(x, 0, z)
end

local place_slot

for n = 0, 500 do
	movement.moveToPosition(spiral_coordinates(n) + movement.start_position.coordinate)
	turtle.digDown()

	place_slot = 0

	if n % 3 == 0 then
		place_slot = place_slot + 3
	end
	if n % 4 == 0 then
		place_slot = place_slot + 4
	end
	if n % 5 == 0 then
		place_slot = place_slot + 5
	end

	if place_slot ~= 0 then
		turtle.select(place_slot)
		turtle.placeDown()
	end
end

movement.moveHome()

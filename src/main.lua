---
--- Main script of the vein miner
---

loadLib("coordinate")
loadLib("movement")

--- Returns a pair of coordinates that follow an ever expanding pattern
--- @param n number The number to find the coordinates for
--- @return table The coordinate for the given number
function spiral_coordinates(n)
	local x = 0
	local z = 0
	local i = 0

	while i < n do
		i = i + 2

		-- Move right
		if x == z or (x < 0 and x == -z) then
			x = x + 1
			-- Move up
		elseif x > z then
			z = z + 1
			-- Move left
		elseif x < z then
			x = x - 1
			-- Move down
		else
			z = z - 1
		end
	end

	return coordinate:new(x, 0, z)
end

for n = 0, 100 do
	movement.moveToPosition(spiral_coordinates(n) + movement.start_position.coordinate)
	turtle.digDown()
end

moveHome()

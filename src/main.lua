---
--- Main script of the vein miner
---

loadLib("coordinate")
loadLib("movement")

--- Returns a pair of coordinates that follow an ever expanding pattern
--- @param n number The number to find the coordinates for
--- @return table The coordinate for the given number
function spiral_coordinates(n)
	local x, z = 0, 0
	local direction = 0

	if n % 2 == 0 then
		x = n / 2
		z = -n / 2
	else
		x = (n + 1) / 2
		z = -(n - 1) / 2
	end

	if n % 4 == 1 then
		direction = 1
	elseif n % 4 == 3 then
		direction = -1
	end

	if direction == 1 then
		x, z = z, x
	elseif direction == -1 then
		x, z = -z, -x
	end

	return coordinate:new(x, 0, z)
end

for n = 0, 100 do
	movement.moveToPosition(spiral_coordinates(n) + movement.start_position.coordinate)
	turtle.digDown()
end

moveHome()

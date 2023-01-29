---
--- Main script of the vein miner
---

loadLib("coordinate")
loadLib("movement")

movement.turnLeft()
movement.turnToFacing(1)
movement.moveUpward()
movement.moveToPosition(coordinate:new(10, 3, -5))
movement.moveHome()


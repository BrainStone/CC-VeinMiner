---
--- Main script of the vein miner
---

loadLib("coordinate")
loadLib("movement")

movement.turnLeft()
movement.turnToFacing(1)

print(movement.current_position.facing)

extends "res://Scripts/Actor.gd"

func _process(delta):
	if InputSystem.input_activation:
		activate_object()
	elif InputSystem.input_direction:
		target_position(InputSystem.input_direction)


# Make a vector of the direction we're facing, then ask the grid to interact
# with whatever is there
func activate_object():
	var direction_of_interaction = Vector2((int(dir == DIR.RIGHT) - int(
			dir == DIR.LEFT)), (int(dir == DIR.DOWN) - int(dir == DIR.UP)))
	overworld.request_interaction(self, direction_of_interaction)
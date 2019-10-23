extends "res://Scripts/OverworldObject.gd"

onready var sprite = $Pivot/Sprite

enum DIR { UP, DOWN, LEFT, RIGHT }
# Allow changing the default facing direction in editor
export(DIR) var dir = DIR.DOWN

# Here you can set which frames represent facing direction
export var down_frame = 0
export var up_frame = 8
export var horiz_frame = 4

func _ready():
	# Set up z index here and simply match it to the y value
	# This allows moving characters like the player to be drawn over
	# a sprite when "in front," but if they move behind that character
	# it will correctly update (sort y order for non-cells)
	z_as_relative = false
	set_z_index(position.y)


# Actor targets a position to move to
func target_position(move_vector):
	var target = overworld.request_move(self, move_vector)
	# Whether we can move or not, update our facing first
	update_facing(move_vector)
	if target:
		move_to(target)
	else:
		bump()


# Change how the character is facing.
func update_facing(direction):
	if direction.x == 1:
		sprite.flip_h = false
		sprite.frame = horiz_frame
		dir = DIR.RIGHT
	elif direction.x == -1:
		sprite.flip_h = true
		sprite.frame = horiz_frame
		dir = DIR.LEFT
	elif direction.y == 1:
		sprite.flip_h = false
		sprite.frame = down_frame
		dir = DIR.DOWN
	elif direction.y == -1:
		sprite.flip_h = false
		sprite.frame = up_frame
		dir = DIR.UP


# Smoothly moves actor to target position
func move_to(target_position):
	# Begin movement. Actor is non-interactive while moving.
	set_process(false)
	process_movement_animation()

	# Move the node to the target cell instantly,
	# and animate the sprite moving from the start to the target cell
	var move_direction = (target_position - position).normalized()
	var current_pos = - move_direction * overworld.cell_size
	# Keep the pivot where it is, because we are about to move the whole
	# transform and it will cause a glitchy animation where the sprite warps
	# for a single frame to the target location (with the transform) and then
	# smoothly animates after
	$Pivot.position = current_pos
	# Move the pivot point from the current position to 0,0
	# (relative to parent transform) basically just catch up with the parent
	$Tween.interpolate_property($Pivot, "position", current_pos, Vector2(),
			$AnimationPlayer.current_animation_length, Tween.TRANS_LINEAR,
			Tween.EASE_IN)
	position = target_position
	# This is basically a "sort y order" option for children (non-cells)
	set_z_index(position.y)
	$Tween.start()

	# Stop the function execution until the animation finished
	yield($AnimationPlayer, "animation_finished")
	# Movement complete. Actor is again "interactive"
	set_process(true)


# Define what an actor should do if it is interacted with in the child class.
func interact():
	print("I am an Actor with no interact defined.")


# Failure to move function.
func bump():
	set_process(false)
	$AnimationPlayer.play("bump")
	yield($AnimationPlayer, "animation_finished")
	set_process(true)


# Movement animation processing
func process_movement_animation():
	match dir:
		DIR.UP:
			$AnimationPlayer.play("walk_up")
		DIR.DOWN:
			$AnimationPlayer.play("walk_down")
		DIR.LEFT:
			$AnimationPlayer.play("walk_horiz")
		DIR.RIGHT:
			$AnimationPlayer.play("walk_horiz")
extends TileMap

enum CELL_TYPES {EMPTY = -1, ACTOR, OBJECT}

var children
var stale_children = false

func _ready():
	process_actor_spawn_conditions()
	refresh_children()


# Make sure to call this when necessary
# We don't want to be getting children everytime an actor tries to move.
func refresh_children():
	children = get_children()


# Iterate through EVERY object in the overworld and find the right one
# Could probably be done better
func get_overworld_obj(coordinates):
	for node in children:
		# Protects against certain situations where an object is queued to be
		# freed
		if !is_instance_valid(node):
			stale_children = true
			continue
		else:
			if world_to_map(node.position) == coordinates:
				return(node)
	if stale_children:
		stale_children = false
		refresh_children()


func request_interaction(requesting_object, direction):
	var cell_start = world_to_map(requesting_object.position)
	var cell_target = world_to_map(requesting_object.position) + direction
	var cell_obj = get_overworld_obj(cell_target)
	if !cell_obj:
		return
	if cell_obj.obj_type != CELL_TYPES.ACTOR:
		return
	cell_obj.interact()


func request_move(requesting_object, direction):
	var cell_start = world_to_map(requesting_object.position)
	var cell_target = world_to_map(requesting_object.position) + direction
	var cell_target_type = get_cellv(cell_target)

	if cell_target_type == CELL_TYPES.EMPTY:
		var cell_obj = get_overworld_obj(cell_target)
		if cell_obj:
			if cell_obj.obj_type == CELL_TYPES.OBJECT:
				cell_obj.do_what_this_object_does()
				return update_overworld_obj_position(requesting_object,
						cell_start, cell_target)
		else:
			return update_overworld_obj_position(requesting_object,
					cell_start, cell_target)

func update_overworld_obj_position(requesting_object, cell_start, cell_target):
	# The cell the moving object was in is now free
	set_cellv(cell_start, CELL_TYPES.EMPTY)

	# Divide by 2 because location 0,0 starts from the top left of the cell
	# and we want the object to be "in the middle" of the grid cell
	return map_to_world(cell_target) + cell_size / 2


# removes an object from children array. The object should queue_free itself,
# but we want the overworld to immediately know this cell is no longer occupied
func remove_from_active(obj):
	children.erase(obj)


# By default design, all potential actors are on scene, and those that do not
# meet their conditions to be present are removed
func process_actor_spawn_conditions():
	for obj in get_children():
		if !obj.spawn_condition():
			obj.call_deferred("free")
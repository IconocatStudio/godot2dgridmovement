extends Node2D

onready var overworld = get_parent()

enum CELL_TYPES { ACTOR, OBJECT }
export(CELL_TYPES) var obj_type = CELL_TYPES.OBJECT

func do_what_this_object_does():
    print(name, " is an OverworldObject that doesn't do anything.")


# An object can specify its condition for being preent in the scene by defining
# this method. By default, if an actor is present in the editor, it will be
# present in game.
func spawn_condition():
	return true
extends "res://Scripts/OverworldObject.gd"

export var target_scene = ""
export var target_spawn_point = 0

func do_what_this_object_does():
	GameData.zone_load_spawn_point = target_spawn_point
	GameData.zone_load_facing_direction = InputSystem.input_direction
	UI.fade_transition_scene(target_scene)
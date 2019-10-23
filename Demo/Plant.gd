extends "res://Scripts/Actor.gd"

func interact():
	print("Player is talking to a plant")


func spawn_condition():
	return GameData.object_picked_up
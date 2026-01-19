@tool
extends Node3D

class_name NPC

@export var path: NPCPath:
	set(value):
		if value and value.resource_path != "":
			path = value.duplicate(true)
			path.resource_local_to_scene = true
			path.connect("changed",update_gizmos)
		path = value
		update_gizmos()

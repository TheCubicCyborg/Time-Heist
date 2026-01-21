@tool
class_name NPC extends Node3D

var prev_paths:Array[String]

@export var path: NPCPath:
	set(value):
		path = value
		update_gizmos()
		if path and not path.changed.is_connected(update_gizmos):
			path.changed.connect(update_gizmos)

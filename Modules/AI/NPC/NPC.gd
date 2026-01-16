@tool
extends Node3D

class_name NPC

@export var path: NPCPath:
	set(value):
		path = value
		update_gizmos()

func _process(_delta):
	if Engine.is_editor_hint():
		pass
	else:
		#handler.process()
		pass

class PathIterator:
	pass

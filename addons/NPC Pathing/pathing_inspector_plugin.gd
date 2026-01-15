extends EditorInspectorPlugin

const toolbar = preload("res://addons/NPC Pathing/pathing_toolbar.tscn")

func _can_handle(object):
	return object is NPC

func _parse_begin(object):
	add_custom_control(toolbar.instantiate())
	print("begin parse")
	

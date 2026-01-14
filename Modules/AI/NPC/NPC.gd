@tool
extends Node3D

class_name NPC

@export var path: NPCPath:
	set(value):
		print("NPC set function")
		if value:
			var copy = value.duplicate(true)
			if copy.array.is_empty():
				copy.array.push_back(TimedAction.new())
			path = copy
		else:
			path = value
		path_changed = true
		update_gizmos()

var path_changed: bool = false #For use with gizmo

var handler: PathHandler

func _ready():
	if Engine.is_editor_hint():
		pass
	else:
		handler = PathHandler.new().init(self)
	

func _process(_delta):
	if Engine.is_editor_hint():
		pass
	else:
		handler.process()

func _physics_process(_delta):
	pass

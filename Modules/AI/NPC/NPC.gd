@tool
extends Node3D

class_name NPC

@export var path: NPCPath:
	set(value):
		path = value
		update_gizmos()

#@export var path: NPCPath
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

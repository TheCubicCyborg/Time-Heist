extends Node3D
class_name Floor

@export var cameras : Array[SubViewport]

func _ready() -> void:
	globals.cameras = cameras
	pass

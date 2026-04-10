@tool
extends CharacterBody3D

@export var camera_up: float = 5.798:
	set(value):
		camera_up = value
		if Engine.is_editor_hint():
			$"Camera Pivot/Camera3D".position.y = value
@export var camera_back: float = 1.928:
	set(value):
		camera_back = value
		if Engine.is_editor_hint():
			$"Camera Pivot/Camera3D".position.z = value

func _ready():
	pass

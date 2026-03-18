extends Node3D
class_name SecurityCamera

@onready var camera: Camera3D = $Camera

var active : bool = true:
	set(value):
		active = value
		@warning_ignore("standalone_ternary")
		camera.show() if value else camera.hide()

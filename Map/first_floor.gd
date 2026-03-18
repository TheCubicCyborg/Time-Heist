extends Floor

@export var cameras : Array[SubViewport]

func _ready() -> void:
	globals.camera_pivots = cameras
	pass

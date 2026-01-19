@tool
class_name PathLine extends PathComponent

@export var speed: float

func _init(_id: int = 0, path:NPCPath = null):
	id = _id
	path = path
	if path:
		speed = path.default_speed

func _to_string():
	return "Line speed:  " + str(speed)

@tool
class_name PathLine extends PathComponent

@export var speed: float

var prev_vertex: PathVertex
var next_vertex: PathVertex

func _init(_prev_vertex = null,_next_vertex = null, _id: int = 0, path:NPCPath = null):
	prev_vertex = _prev_vertex
	next_vertex = _next_vertex
	id = _id
	path = path
	if path:
		speed = path.default_speed

func _to_string():
	return "Line speed:  " + str(speed)

@tool
class_name PathLine extends PathComponent

@export var speed: float:
	set(value):
		speed = value
		emit_component_changed()

var prev_vertex: PathVertex
var next_vertex: PathVertex

func _init(_prev_vertex = null,_next_vertex = null, _id: int = 0, path:NPCPath = null):
	super(_id,path)
	prev_vertex = _prev_vertex
	next_vertex = _next_vertex
	if path:
		speed = path.default_speed

func _to_string():
	return "Line speed:  " + str(speed)

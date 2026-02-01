@tool
class_name PathLine extends PathComponent

@export var speed: float:
	set(value):
		if path and path.updating_path:
			speed = value
			emit_changed()
		else:
			emit_manual_change("speed",value)

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

func recalculate_speed():
	var duration: float = time_end - time_start
	if is_zero_approx(duration):
		speed = INF
	else:
		speed = get_length()/duration

func get_length():
	return prev_vertex.position.distance_to(next_vertex.position)

func _validate_property(property: Dictionary):
	if property.name == "time_start":
		property.usage |= PROPERTY_USAGE_READ_ONLY
	if property.name == "time_end":
		property.usage |= PROPERTY_USAGE_READ_ONLY

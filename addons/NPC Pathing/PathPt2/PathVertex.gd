@tool
class_name PathVertex extends PathComponent

@export var position: Vector3:
	set(value):
		position = value
		emit_changed()

@export var vertex_actions: Array[VertexAction]

func _init(_id: int = 0, _path: NPCPath = null):
	id = _id
	path = _path
	changed.connect(path.vertex_changed)

func _to_string():
	return "Vertex at " + str(position)

func _validate_property(property: Dictionary):
	if id == 0:
		if property.name == "time_start":
			property.usage |= PROPERTY_USAGE_READ_ONLY
		if property.name == "position":
			property.usage |= PROPERTY_USAGE_READ_ONLY

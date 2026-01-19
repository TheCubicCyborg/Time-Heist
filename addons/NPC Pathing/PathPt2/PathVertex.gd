@tool
class_name PathVertex extends PathComponent

@export var position: Vector3

@export var vertex_actions: Array[VertexAction]

func _init(_id: int = 0, path:NPCPath = null):
	id = _id
	path = path

func _to_string():
	return "Vertex at " + str(position)

func _validate_property(property: Dictionary):
	if id == 0:
		if property.name == "time_start":
			property.usage |= PROPERTY_USAGE_READ_ONLY
		if property.name == "position":
			property.usage |= PROPERTY_USAGE_READ_ONLY

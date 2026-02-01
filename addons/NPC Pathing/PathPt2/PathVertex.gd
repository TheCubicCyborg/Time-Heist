@tool
class_name PathVertex extends PathComponent

@export var position: Vector3:
	set(value):
		if path and path.updating_path:
			position = value
			emit_changed()
		else:
			emit_manual_change("position",value)

@export var vertex_actions: Array[VertexAction]

func _to_string():
	return "Vertex at " + str(position)

func get_duration():
	var duration: float = 0
	for action in vertex_actions:
		if action is WaitVertexAction:
			duration += action.duration
	return duration

func _validate_property(property: Dictionary):
	if id == 0:
		if property.name == "time_start":
			property.usage |= PROPERTY_USAGE_READ_ONLY
		if property.name == "position":
			property.usage |= PROPERTY_USAGE_READ_ONLY

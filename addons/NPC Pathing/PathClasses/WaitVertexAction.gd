@tool
class_name WaitVertexAction extends VertexAction

@export var start_time: float:
	set(value):
		start_time = value
@export var end_time: float:
	set(value):
		if value < start_time:
			end_time = start_time
		else:
			end_time = value
		if Engine.is_editor_hint():
			if EditorInterface.get_edited_scene_root() and not editing_action:
				editing_action = true
				duration = end_time - start_time
				editing_action = false
				validate_action.emit()
				emit_changed()
@export var duration: float:
	set(value):
		duration = value
		if Engine.is_editor_hint():
			if EditorInterface.get_edited_scene_root() and not editing_action:
				editing_action = true
				end_time = start_time + duration
				editing_action = false
				validate_action.emit()
				emit_changed()

var editing_action: bool = false

signal validate_action

func _validate_property(property: Dictionary):
	if property.name == "start_time":
		property.usage |= PROPERTY_USAGE_READ_ONLY

@tool
@abstract
class_name PathComponent extends Resource

@export var time_start: float:
	set(value):
		time_start = value
		emit_component_changed("time_start")
@export var time_end: float:
	set(value):
		time_end = value
		emit_component_changed("time_end")

var id: int
var path: NPCPath

signal component_changed(id_changed: int)

func _init(_id: int = 0, _path: NPCPath = null):
	id = _id
	path = _path
	if path:
		component_changed.connect(path.component_changed)

func emit_component_changed(property_name: String):
	component_changed.emit(id,property_name)

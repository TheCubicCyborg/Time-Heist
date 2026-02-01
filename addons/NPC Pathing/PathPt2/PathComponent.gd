@tool
@abstract
class_name PathComponent extends Resource

@export var time_start: float:
	set(value):
		if path and path.updating_path:
			time_start = value
			emit_changed()
		else:
			emit_manual_change("time_start",value)
@export var time_end: float:
	set(value):
		if path and path.updating_path:
			time_end = value
			emit_changed()
		else:
			emit_manual_change("time_end",value)

var id: int
var path: NPCPath

signal manual_change(component: PathComponent,property_name:String, value: Variant)

func _init(_id: int = 0, _path: NPCPath = null):
	id = _id
	path = _path
	if path:
		manual_change.connect(path.component_manually_changed)
		changed.connect(path.emit_changed)

func emit_manual_change(property_name: String, value: Variant):
	manual_change.emit(self,property_name,value)

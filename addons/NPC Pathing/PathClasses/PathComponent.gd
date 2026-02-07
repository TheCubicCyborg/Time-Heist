@tool
@abstract
class_name PathComponent extends Resource

@export var time_start: float:
	set(value):
		var old = time_start
		time_start = value
		emit_manual_change("time_start",old)
@export var time_end: float:
	set(value):
		var old = time_end
		time_end = value
		emit_manual_change("time_end",old)

@export var id: int

signal manual_change(component: PathComponent,property_name:String, value: Variant)

func _init(_id: int = 0, _path: NPCPath = null):
	#print("initializing path component")
	resource_local_to_scene = true
	id = _id
	if _path:
		manual_change.connect(_path.component_manually_changed)
		changed.connect(_path.emit_changed)

func emit_manual_change(property_name: String, value: Variant):
	manual_change.emit(self,property_name,value)

func _validate_property(property: Dictionary):
	if property.name == "id":
		property.usage = PROPERTY_USAGE_STORAGE

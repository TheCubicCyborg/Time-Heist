@tool
class_name PathVertex extends PathComponent


@export var position: Vector3:
	set(value):
		var old = position
		position = value
		emit_manual_change("position",old)

@export var vertex_actions: Array[VertexAction]:
	set(value):
		#print("vertex actions changed")
		vertex_actions = value
		if Engine.is_editor_hint():
			if EditorInterface.get_edited_scene_root():
				_validate_actions()
			else:
				verify_signals()
			vertex_action_changed()

func _init(_id: int = 0, _path: NPCPath = null):
	super(_id,_path)

func _to_string():
	return "Vertex at " + str(position)

func num_actions():
	return vertex_actions.size()

func action(ix: int) -> VertexAction:
	return vertex_actions[ix]

func get_duration():
	var duration: float = 0
	for action in vertex_actions:
		if action is WaitVertexAction:
			duration += action.duration
	return duration

func _validate_property(property: Dictionary):
	super(property)
	if id == 0:
		if property.name == "time_start":
			property.usage |= PROPERTY_USAGE_READ_ONLY
		if property.name == "position":
			property.usage |= PROPERTY_USAGE_READ_ONLY

func _validate_actions():
	var cur_start_time = time_start
	for action: VertexAction in vertex_actions:
		if action is WaitVertexAction:
			action.editing_action = true
			action.start_time = cur_start_time
			action.end_time = action.start_time + action.duration
			cur_start_time = action.end_time
			action.editing_action = false
	verify_signals()

func verify_signals():
	for action: VertexAction in vertex_actions:
		if action is WaitVertexAction:
			if not action.changed.is_connected(vertex_action_changed):
				action.changed.connect(vertex_action_changed)
			if not action.validate_action.is_connected(_validate_actions):
				action.validate_action.connect(_validate_actions)

func vertex_action_changed():
	emit_manual_change("vertex_actions",null)

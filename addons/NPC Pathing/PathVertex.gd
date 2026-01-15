class_name PathVertex

var action_start_ix: int
var actions: Array[NPCAction] = []
var position: Vector3
func _init(_start_index: int, _position:Vector3):
	action_start_ix = _start_index
	position = _position

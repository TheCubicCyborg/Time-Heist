extends Node

@export var rotation_speed : float = 15.0

var face_to_move = {
	0 : ["player_left", "player_right", "player_up", "player_down"],
	1 : ["player_up", "player_down", "player_right", "player_left"],
	2 : ["player_right", "player_left", "player_down", "player_up"],
	3 : ["player_down", "player_up", "player_left", "player_right"],
}

var input_map
var should_update_map : bool = false

func _ready() -> void:
	input_map = face_to_move[0] # Initally set input map

func get_input_direction() -> Vector2:
	if not globals.player.can_move:
		return Vector2.ZERO
	# Get input (based on mapping from direction it is facing)
	var input_dir := Input.get_vector(input_map[0],input_map[1],input_map[2],input_map[3])
	# Update maping (only if should)
	if should_update_map and input_dir != globals.player.previous_input:
		input_map = face_to_move[globals.camera.facing_direction]
		should_update_map = false
	
	if input_dir != globals.player.previous_input: #and input_dir != Vector2.ZERO
		#velocity = Vector3.ZERO TODO i dont think this is useful
		globals.player.previous_input = input_dir # Stores previous input (for the above check)
		
	return input_dir

func get_direction_vector(input_dir : Vector2) -> Vector3:
	var direction_facing = get_parent().get_direction_facing()
	return (direction_facing * Vector3(abs(input_dir.x), 0, abs(input_dir.y))).normalized()

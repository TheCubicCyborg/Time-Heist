extends State

@export
var walking_state : State

func enter() -> void:
	player.velocity = Vector3.ZERO
	move_component.added_velocity = 0
	pass
	
func exit() -> void:
	pass
	
func process_input(event: InputEvent) -> State:
	if Input.is_action_pressed("player_left") or Input.is_action_pressed("player_right") or Input.is_action_pressed("player_up") or Input.is_action_pressed("player_down"):
		return walking_state
	return null
	
func process_physics(delta: float) -> State:
	return null
	
func process_frame(delta: float) -> State:
	print("IDLE")
	return null

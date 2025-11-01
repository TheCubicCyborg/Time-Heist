extends State

@export
var walking_state : State
@export
var idle_state : State

#var added_velocity

func enter() -> void:
	print("ENTERING")
	#Play sliding animation
	pass
	
func exit() -> void:
	pass
	
func process_input(event: InputEvent) -> State:
	if Input.is_action_pressed("player_left") or Input.is_action_pressed("player_right") or Input.is_action_pressed("player_up") or Input.is_action_pressed("player_down"):
		return walking_state
	return null
	
func process_physics(delta: float) -> State:
	print(globals.player.velocity)
	print("STOPPING")
	move_component.added_velocity = lerp(move_component.added_velocity, 0.0, delta * move_component.STOP_ACCELERATION) # maybe move this lerp to the move component
	player.velocity = move_component.added_velocity * (move_component.get_direction_facing().normalized())
	
	
	
	if player.velocity == Vector3.ZERO:
		return idle_state
	return null
	
func process_frame(delta: float) -> State:
	return null

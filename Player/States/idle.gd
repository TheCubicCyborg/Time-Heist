extends State
class_name Idle

@export_category("States")
@export
var walking_state : State
@export
var dash_state : State
@export
var sneak_state : State

func enter() -> void:
	player.velocity = Vector3.ZERO
	player.speed = 0
	pass
	
func exit() -> void:
	pass
	
func process_input(event: InputEvent) -> State:
	if PlayerInput.is_action_just_pressed("player_dash"):
		return dash_state
	return null
	
func process_physics(delta: float) -> State:
	return null
	
func process_frame(delta: float) -> State:
	if input_controller.get_input_direction() != Vector2.ZERO:
		if PlayerInput.is_action_pressed("player_dash"):
			return dash_state
		return walking_state
	return null

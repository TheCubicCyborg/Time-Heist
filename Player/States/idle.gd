extends State
class_name Idle

@export_category("States")
@export
var walking_state : State
@export
var running_state : State

func enter() -> void:
	player.animation_player.play("idle")
	player.velocity = Vector3.ZERO
	player.speed = 0
	pass
	
func exit() -> void:
	player.animation_player.stop()
	pass
	
func process_input(event: InputEvent) -> State:
	#if PlayerInput.is_action_just_pressed("player_roll_walk"):
		#return dash_state
	return null
	
func process_physics(delta: float) -> State:
	return null
	
func process_frame(delta: float) -> State:
	if input_controller.get_input_direction() != Vector2.ZERO:
		if PlayerInput.is_action_pressed("player_roll_walk"):
			return walking_state
		return running_state
	return null

extends State
class_name Sneak_Checking

@export_category("States")
@export
var walking_state : State
@export
var dash_state : State
@export
var crouching_state: State

func enter() -> void:
	if player.sneak_detect.get_sneak_start_point():
		print(player.sneak_detect.get_sneak_start_point())
		if(player.sneak_detect.get_sneak_start_point()[1]):
			player.is_crouching = true
	else:
		print("didnt find any")
	pass
	
func exit() -> void:
	pass
	
func process_input(event: InputEvent) -> State:
	if Input.is_action_pressed("player_left") or Input.is_action_pressed("player_right") or Input.is_action_pressed("player_up") or Input.is_action_pressed("player_down"):
		return walking_state
	if Input.is_action_just_pressed("player_crouch"):
		return crouching_state
	return null
	
func process_physics(delta: float) -> State:
	player.position = lerp(player.position, player.sneak_detect.get_sneak_start_point()[0], 2 * delta)
	return null
	
func process_frame(delta: float) -> State:
	return null

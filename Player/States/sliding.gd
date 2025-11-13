extends State
class_name Sliding

@export_category("States")
@export
var walking_state : State
@export
var idle_state : State
@export
var dash_state : State
@export
var sneak_checking_state : State
@export
var crouching_state: State

#var added_velocity

func enter() -> void:
	#Play sliding animation
	player.current_max_speed = player.max_speed_sliding
	player.current_acceleration = 2 * player.current_acceleration * player.speed/player.max_speed_dashing
	pass
	
func exit() -> void:
	pass
	
func process_input(event: InputEvent) -> State:
	if player.can_move and Input.is_action_just_pressed("player_dash"):
		return dash_state
	if Input.is_action_just_pressed("player_sneak"):
		return sneak_checking_state
	#if Input.is_action_just_pressed("player_crouch"):
		#return crouching_state
	return null
	
func process_physics(delta: float) -> State:
	
	player.speed = lerp(player.speed, player.current_max_speed, delta * 4)
	player.velocity = player.speed * (player.get_direction_facing().normalized())
	
	player.move_and_slide()

	if player.speed < 0.2: #no_small_values(abs(player.velocity)):
		return idle_state
	return null
	
func process_frame(delta: float) -> State:
	if move_component.get_input_direction() != Vector2.ZERO:
		if Input.is_action_pressed("player_dash"):
			return dash_state
		return walking_state
	return null

#func no_small_values(vector : Vector3):
	#var threshhold = 0.9
	#if vector.x <= threshhold and vector.y <= threshhold and vector.z <= threshhold:
		#return true
	#return false

extends State
class_name Walking

#ANY EXPORTS?
@export_category("States")
@export
var idle_state : State
@export 
var sliding_state : State
@export
var dash_state : State
@export
var sneak_checking_state : State
@export
var crouching_state: State

func enter() -> void:
	if player.is_crouching:
		player.current_max_speed = player.max_speed_crouching
		player.current_acceleration = player.acceleration_crouching
	else:
		player.current_max_speed = player.max_speed_walking
		player.current_acceleration = player.acceleration_walking
	pass
	
func exit() -> void:
	pass
	
func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed("player_dash"):
		return dash_state
	if Input.is_action_just_pressed("player_sneak"):
		return sneak_checking_state
	#if Input.is_action_just_pressed("player_crouch"):
		#return crouching_state
	return null
	
func process_physics(delta: float) -> State:
	
	if not player.is_on_floor():
		player.velocity += player.get_gravity() * delta

	var input_dir = input_controller.get_input_direction() # Input direction
	var direction_vector = input_controller.get_direction_vector(input_dir) # Direction vector
	
	player.speed = lerp(player.speed, player.current_max_speed, player.current_acceleration * delta)
	player.velocity = player.speed * direction_vector

	player.move_and_slide()
	
	return null
	
func process_frame(delta: float) -> State:
	if input_controller.get_input_direction() == Vector2.ZERO:
		return sliding_state
	if Input.is_action_pressed("player_dash"):
		return dash_state
	
	if player.is_crouching:
		player.current_acceleration = player.deceleration_crouching
		player.current_max_speed = player.max_speed_crouching
	else:
		player.current_acceleration = player.deceleration_walking
		player.current_max_speed = player.max_speed_walking
	if player.speed > player.current_max_speed:
		if player.is_crouching:
			player.current_acceleration = player.deceleration_crouching
		else:
			player.current_acceleration = player.deceleration_walking
	else:
		if player.is_crouching:
			player.current_acceleration = player.acceleration_crouching
		else:
			player.current_acceleration = player.acceleration_walking
	return null

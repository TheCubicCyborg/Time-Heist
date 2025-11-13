extends State
class_name Dash

@export_category("States")
@export
var idle_state : State
@export
var walking_state : State
@export
var sliding_state : State
@export
var sneak_checking_state : State
@export
var crouching_state: State


#var added_velocity

func enter() -> void:
	if player.is_crouching:
		player.is_crouching = false
	player.speed += player.instant_speed_dashing
	player.current_acceleration = player.acceleration_dashing
	player.current_max_speed = player.max_speed_dashing
	player.velocity = player.speed * (player.get_direction_facing().normalized())
	pass
	
func exit() -> void:
	pass
	
func process_input(event: InputEvent) -> State:
	if input_controller.get_input_direction() == Vector2.ZERO:
		return sliding_state
	return null
	
func process_physics(delta: float) -> State:
	if not player.is_on_floor():
		player.velocity += player.get_gravity() * delta

	var input_dir = input_controller.get_input_direction() # Input direction
	var direction_vector = input_controller.get_direction_vector(input_dir) # Direction vector
	
	player.speed = lerp(player.speed, player.current_max_speed, player.current_acceleration * delta)
	player.velocity = player.speed * direction_vector

	player.move_and_slide()
	
	#OLD CODE
	#player.speed = lerp(player.speed, 0.0, delta * player.current_acceleration)
	#var input_dir = input_controller.get_input_direction()
	#var direction_vector = input_controller.get_direction_vector(input_dir)
	#player.velocity = player.speed * direction_vector
	#
	#player.move_and_slide()
#
	#if player.speed < 1:
		#return idle_state
	return null
	
func process_frame(delta: float) -> State:
	if player.is_crouching:
		player.current_acceleration = player.deceleration_crouching
		player.current_max_speed = player.max_speed_crouching
	else:
		player.current_acceleration = player.deceleration_dashing
		player.current_max_speed = player.max_speed_dashing
		
	if player.speed > player.current_max_speed:
		if player.is_crouching:
			player.current_acceleration = player.deceleration_crouching
		else:
			player.current_acceleration = player.deceleration_dashing
	else:
		if player.is_crouching:
			player.current_acceleration = player.acceleration_crouching
		else:
			player.current_acceleration = player.acceleration_dashing
	
	if input_controller.get_input_direction() == Vector2.ZERO:
		return sliding_state
	if Input.is_action_pressed("player_dash"):
		return null
	return sliding_state

func no_small_values(vector : Vector3):
	var threshhold = 4.5
	if vector.x <= threshhold and vector.z <= threshhold:
		return true
	return false

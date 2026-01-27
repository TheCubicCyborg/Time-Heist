extends State
class_name Running

@export_category("States")
@export
var idle_state : State
@export
var walking_state : State
@export
var sliding_state : State

func enter() -> void:
	#player.anim_tree.set("parameters/PlayerAnimations/Movement/transition_request","Running")
	if player.is_crouching:
		player.current_max_speed = player.max_speed_crouching
		player.current_acceleration = player.acceleration_crouching
	else:
		player.current_max_speed = player.max_speed_running
		player.current_acceleration = player.acceleration_running
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
	
	return null
	
func process_frame(delta: float) -> State:
	if input_controller.get_input_direction() == Vector2.ZERO:
		return sliding_state
	if PlayerInput.is_action_pressed("player_roll_walk"):
		return walking_state
		
	if player.is_crouching:
		player.current_acceleration = player.deceleration_crouching
		player.current_max_speed = player.max_speed_crouching
	else:
		player.current_acceleration = player.deceleration_running
		player.current_max_speed = player.max_speed_running
		
	if player.speed > player.current_max_speed:
		if player.is_crouching:
			player.current_acceleration = player.deceleration_crouching
		else:
			player.current_acceleration = player.deceleration_running
	else:
		if player.is_crouching:
			player.current_acceleration = player.acceleration_crouching
		else:
			player.current_acceleration = player.acceleration_running

	return null

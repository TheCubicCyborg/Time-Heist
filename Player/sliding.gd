extends State

@export
var walking_state : State
@export
var idle_state : State
@export
var dash_state : State

#var added_velocity

func enter() -> void:
	#Play sliding animation
	pass
	
func exit() -> void:
	pass
	
func process_input(event: InputEvent) -> State:
	if Input.is_action_pressed("player_left") or Input.is_action_pressed("player_right") or Input.is_action_pressed("player_up") or Input.is_action_pressed("player_down"):
		return walking_state
	if Input.is_action_just_pressed("player_dash"):
		return dash_state
	return null
	
func process_physics(delta: float) -> State:
	var deceleration = 2 * move_component.ACCELERATION * (move_component.added_velocity / move_component.MAX_SPEED)
	
	move_component.added_velocity = lerp(move_component.added_velocity, 0.0, delta * deceleration) # maybe move this lerp to the move component
	player.velocity = move_component.added_velocity * (move_component.get_direction_facing().normalized())
	
	player.move_and_slide()

	if move_component.added_velocity < 1: #no_small_values(abs(player.velocity)):
		return idle_state
	return null
	
func process_frame(delta: float) -> State:
	return null

#func no_small_values(vector : Vector3):
	#var threshhold = 0.9
	#if vector.x <= threshhold and vector.y <= threshhold and vector.z <= threshhold:
		#return true
	#return false

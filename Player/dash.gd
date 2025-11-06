extends State

@export
var dash_strength : int = 20
@export
var deceleration : int = 5

@export
var idle_state : State
@export
var walking_state : State
@export
var sliding_state : State


#var added_velocity

func enter() -> void:
	move_component.added_velocity += dash_strength
	player.velocity = move_component.added_velocity * (move_component.get_direction_facing().normalized())
	pass
	
func exit() -> void:
	pass
	
func process_input(event: InputEvent) -> State:
	if no_small_values(abs(player.velocity)) and (Input.is_action_pressed("player_left") or Input.is_action_pressed("player_right") or Input.is_action_pressed("player_up") or Input.is_action_pressed("player_down")):
		return walking_state
	return null
	
func process_physics(delta: float) -> State:
	#print(move_component.added_velocity)
	print(abs(player.velocity).x, abs(player.velocity).y, abs(player.velocity).z)
	
	move_component.added_velocity = lerp(move_component.added_velocity, 0.0, delta * deceleration) # maybe move this lerp to the move component
	player.velocity = move_component.added_velocity * (move_component.get_direction_facing().normalized())
	
	player.move_and_slide()

	if move_component.added_velocity < 1:
		return idle_state
	return null
	
func process_frame(delta: float) -> State:
	return null

func no_small_values(vector : Vector3):
	var threshhold = 3.0
	if vector.x <= threshhold and vector.z <= threshhold:
		return true
	return false

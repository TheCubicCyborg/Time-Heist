extends State

@export
var idle_state : State
@export
var walking_state : State
@export
var sliding_state : State


#var added_velocity

func enter() -> void:
	move_component.added_velocity += 10
	player.velocity = move_component.added_velocity * (move_component.get_direction_facing().normalized())
	pass
	
func exit() -> void:
	pass
	
func process_input(event: InputEvent) -> State:
	if move_component.added_velocity < 5 and (Input.is_action_pressed("player_left") or Input.is_action_pressed("player_right") or Input.is_action_pressed("player_up") or Input.is_action_pressed("player_down")):
		print("YAY") #why i this not working when holding down
		return walking_state
	return null
	
func process_physics(delta: float) -> State:
	print(move_component.added_velocity)
	var deceleration = 4
	
	move_component.added_velocity = lerp(move_component.added_velocity, 0.0, delta * deceleration) # maybe move this lerp to the move component
	player.velocity = move_component.added_velocity * (move_component.get_direction_facing().normalized())
	
	player.move_and_slide()

	if move_component.added_velocity < 1:
		return idle_state
	return null
	
func process_frame(delta: float) -> State:
	return null

#func no_small_values(vector : Vector3):
	#var threshhold = 2
	#if vector.x <= threshhold and vector.y <= threshhold and vector.z <= threshhold:
		#return true
	#return false

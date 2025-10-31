extends State

#ANY EXPORTS?
@export
var idle_state : State

var added_velocity := 0.0

func enter() -> void:
	pass
	
func exit() -> void:
	pass
	
func process_input(event: InputEvent) -> State:
	return null
	
func process_physics(delta: float) -> State:
	if not player.is_on_floor():
		player.velocity += player.get_gravity() * delta

	var input_dir = move_component.get_input_direction() # Input direction
	var direction_vector = move_component.get_direction_vector(input_dir) # Direction vector
	
	added_velocity = lerp(added_velocity, move_component.MAX_SPEED, move_component.ACCELERATION * delta)
	if input_dir == Vector2.ZERO: #if stop moving -> velocity = 0
		return idle_state
	player.velocity = added_velocity * direction_vector
	
	if input_dir:
		player.rotation.y = lerp_angle(player.rotation.y, atan2(-input_dir.x, -input_dir.y), delta * move_component.rotation_speed)

	player.move_and_slide()
	
	return null
	
func process_frame(delta: float) -> State:
	return null

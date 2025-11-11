extends State
class_name Crouching

var mat : StandardMaterial3D

@export_category("States")
@export
var walking_state : State
@export
var idle_state : State
@export 
var sliding_state : State
@export
var dash_state : State
@export
var sneak_checking_state : State

#var added_velocity := 0.0

func enter() -> void:
	mat = player.mesh.get_surface_override_material(0)
	mat.albedo_color = Color(0.982, 0.502, 1.0, 1.0)
	pass
	
func exit() -> void:
	pass
	
func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed("player_sneak"):
		return sneak_checking_state
	if Input.is_action_just_pressed("player_crouch") and player.speed == 0:
		mat.albedo_color = Color(1.0, 1.0, 1.0, 1.0) 
		return idle_state
	elif Input.is_action_just_pressed("player_crouch"):
		mat.albedo_color = Color(1.0, 1.0, 1.0, 1.0) 
		return walking_state
	return null
	
func process_physics(delta: float) -> State:
	
	if not player.is_on_floor():
		player.velocity += player.get_gravity() * delta

	var input_dir = move_component.get_input_direction() # Input direction
	var direction_vector = move_component.get_direction_vector(input_dir) # Direction vector
	
	player.speed = lerp(player.speed, player.speed / 2.3, player.acceleration * delta)
	if input_dir == Vector2.ZERO: #if stop moving -> velocity = 0
		player.speed = 0
	player.velocity = player.speed * direction_vector

	player.move_and_slide()
	
	return null
	
func process_frame(delta: float) -> State:
	return null

extends State
class_name Sneak_Checking

@export_category("States")
@export
var walking_state : State
@export
var dash_state : State

var start_sneak_point

func enter() -> void:
	if(globals.player.sneak_detect.get_sneak_start_point()[1]):
		globals.player.is_crouching = true
		globals.player.mesh.get_surface_override_material(0).albedo_color = Color(1.0, 1.0, 1.0, 1.0)
	start_sneak_point = player.sneak_detect.get_sneak_start_point()[0]
	pass
	
func exit() -> void:
	pass
	
func process_input(event: InputEvent) -> State:
	return null
	
func process_physics(delta: float) -> State:
	player.position = lerp(player.position, start_sneak_point, 2 * delta)
	return null
	
func process_frame(delta: float) -> State:
	if input_controller.get_input_direction() != Vector2.ZERO:
		if PlayerInput.is_action_pressed("player_dash"):
			return dash_state
		return walking_state
	return null

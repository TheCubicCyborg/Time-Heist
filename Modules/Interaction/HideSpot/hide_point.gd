extends Marker3D
class_name HidePoint

var player_inside: bool = false
var saved_position: Vector3

func interact(person: Node) -> void:
	if person == globals.player:
		if not player_inside:
			enter_locker(person)
		else:
			exit_locker(person)

func enter_locker(player: Player) -> void:
	player_inside = true
	player.is_hidden = true
	
	player.set_physics_process(false)  # lock movement
	player.set_process_input(false)    # lock input idk if this works lol
	
	saved_position = player.global_position
	player.global_position = global_position  # snap to locker
	
	player.visible = false

func exit_locker(player: Player) -> void:
	player_inside = false
	player.is_hidden = false
	
	player.set_physics_process(true)
	player.set_process_input(true)
	
	player.global_position = saved_position
	player.visible = true

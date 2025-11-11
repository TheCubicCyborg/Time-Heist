extends Node

@export var starting_state: State

var current_state: State
# Called when the node enters the scene tree for the first time.
func init(move_component: Node) -> void:
	for child in get_children():
		child.player = globals.player
		child.move_component = move_component
	
	change_state(starting_state)

func change_state(new_state : State) -> void:
	if current_state:
		current_state.exit()
		
	current_state = new_state
	current_state.enter()
	
func handle_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("player_crouch"):
		globals.player.is_crouching = !globals.player.is_crouching
		return
	var new_state = current_state.process_input(event)
	if new_state:
		change_state(new_state)

func handle_physics(delta: float) -> void:
	var new_state = current_state.process_physics(delta)
	if new_state:
		change_state(new_state)
		
func handle_frame(delta: float) -> void:
	#print(globals.player.speed)
	var new_state = current_state.process_frame(delta)
	if new_state:
		change_state(new_state)

extends Node

enum InputControllers {UI, GAMEPLAY, NONE}

var in_control = InputControllers.GAMEPLAY

var camera_sens_hor: float = 50

func _ready():
	change_input_controller(in_control)

func change_input_controller(controller: InputControllers):
	match controller:
		InputControllers.UI:
			_switch_to_ui()
		InputControllers.GAMEPLAY:
			_switch_to_gameplay()
		InputControllers.NONE:
			_switch_to_none()

func _physics_process(delta):
	match in_control:
		InputControllers.UI:
			_process_UI(delta)
		InputControllers.GAMEPLAY:
			_process_gameplay(delta)
		InputControllers.NONE:
			pass

func _input(event):
	match in_control:
		InputControllers.UI:
			_input_UI(event)
		InputControllers.GAMEPLAY:
			_input_gameplay(event)
		InputControllers.NONE:
			pass

#region None
func _switch_to_none():
	in_control = InputControllers.NONE
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

#endregion

#region UI
func _switch_to_ui():
	in_control = InputControllers.UI
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _input_UI(event: InputEvent):
	pass

func _process_UI(delta: float):
	if Input.is_action_just_pressed("escape"):
		change_input_controller(InputControllers.GAMEPLAY)

#endregion

#region Gameplay
func _switch_to_gameplay():
	in_control = InputControllers.GAMEPLAY
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input_gameplay(event: InputEvent):
	if event is InputEventMouseMotion:
		globals.player2.pan_camera_horizontally(-deg_to_rad(event.screen_relative.x * (camera_sens_hor/100)))

func _process_gameplay(_delta: float):
	if globals.player2:
		globals.player2.move(Input.get_vector("player_left","player_right","player_down","player_up"))
	
	if Input.is_action_just_pressed("escape"):
		change_input_controller(InputControllers.UI)
#endregion

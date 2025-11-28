extends Control
class_name UI_Manager

@onready var document_viewer = $DocumentViewer
@onready var debug_ui = $"DEBUG UI"
@export var debug_mode: bool = false
@onready var camera_ui = $Camera
@export var camera_mode: bool = false
var control_input: bool = false
var ui_stack: Array[Control] = []
var cur_ui: Control = null


func _ready():
	globals.ui_manager = self
	toggle_debug(false)
	toggle_camera(false)

func _process(_delta):
	handle_debug_input()
	handle_input()
	if control_input:
		cur_ui.handle_input()

func take_control(UI: Control):
	control_input = true
	globals.controller_of_input = globals.InputController.UI
	if cur_ui:
		ui_stack.append(cur_ui)
	cur_ui = UI

func release_control():
	if not ui_stack.is_empty():
		cur_ui = ui_stack.pop_back()
	else:
		cur_ui = null
		control_input = false
		globals.controller_of_input = globals.InputController.GAMEPLAY

func handle_debug_input():
	if not debug_mode and Input.is_action_just_released("debug_button"):
		toggle_debug(true)

func handle_input():
	if not camera_mode and Input.is_action_just_pressed("camera_ui"):
		toggle_camera(true)
	elif Input.is_action_just_pressed("camera_ui"):
		toggle_camera(false)

func toggle_camera(value:bool):
	camera_mode = value
	if not camera_ui:
		return
	if value:
		camera_ui.visible = true
		camera_ui.process_mode = Node.PROCESS_MODE_INHERIT
	else:
		camera_ui.visible = false
		camera_ui.process_mode = Node.PROCESS_MODE_DISABLED

func toggle_debug(value:bool):
	debug_mode = value
	if not debug_ui:
		return
	if value:
		debug_ui.visible = true
		debug_ui.process_mode = Node.PROCESS_MODE_INHERIT
	else:
		debug_ui.visible = false
		debug_ui.process_mode = Node.PROCESS_MODE_DISABLED

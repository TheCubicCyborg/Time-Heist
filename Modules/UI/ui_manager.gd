extends Control
class_name UI_Manager

@onready var document_viewer = $DocumentViewer
@onready var debug_ui = $"DEBUG UI"
@export var debug_mode: bool = false
@onready var camera_ui = $Camera
@onready var device_menu = $DeviceMenu
#var control_input: bool = false
var ui_stack: Array[Control] = []
var cur_ui: Control = null


func _ready():
	globals.ui_manager = self
	set_menu(device_menu,false)
	set_menu(debug_ui,debug_mode)
	set_menu(document_viewer,false)

func _process(_delta):
	handle_input()
	if globals.controller_of_input == globals.InputController.UI:
		cur_ui.handle_input()

func take_control(ui: Control):
	globals.controller_of_input = globals.InputController.UI
	if cur_ui:
		ui_stack.append(cur_ui)
	cur_ui = ui

func release_control():
	if not ui_stack.is_empty():
		cur_ui = ui_stack.pop_back()
	else:
		cur_ui = null
		globals.controller_of_input = globals.InputController.GAMEPLAY

func handle_input():
	if Input.is_action_just_pressed("camera_ui"):
		toggle_menu(camera_ui)
	if Input.is_action_just_pressed("debug_button"):
		toggle_menu(debug_ui)
	if Input.is_action_just_pressed("device_menu"):
		toggle_menu(device_menu)

func toggle_menu(ui:UI):
	if not ui.is_open:
		ui.open()
	else:
		ui.close()
		
func set_menu(ui:UI,value:bool):
	if value:
		ui.open()
	else:
		ui.close()

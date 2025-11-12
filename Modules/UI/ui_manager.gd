extends Control
class_name UI_Manager

@onready var document_viewer = $DocumentViewer
@onready var debug_ui = $"DEBUG UI"
@export var debug_mode: bool = false
var control_input: bool = false
var ui_stack: Array[Control] = []
var cur_ui: Control = null


func _ready():
	globals.ui_manager = self
	toggle_debug(false)

func _process(_delta):
	handle_debug_input()
	if control_input:
		cur_ui.handle_input()

func take_control(UI: Control):
	control_input = true
	if cur_ui:
		ui_stack.append(cur_ui)
	cur_ui = UI

func release_control():
	if not ui_stack.is_empty():
		cur_ui = ui_stack.pop_back()
	else:
		control_input = false

func handle_debug_input():
	if not debug_mode and Input.is_action_just_released("debug_button"):
		toggle_debug(true)

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

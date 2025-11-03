@tool
extends Control

@export var debug_mode: bool = false:
	set(value):
		toggle_debug(value)
		debug_mode = value

func _ready():
	pass

func _process(_delta):
	if not Engine.is_editor_hint():
		handle_debug_input()

func handle_debug_input():
	if not debug_mode and Input.is_action_just_released("debug_button"):
		debug_mode = true

func toggle_debug(value:bool):
	var debug_ui = $"DEBUG UI"
	if not debug_ui:
		return
	if value:
		debug_ui.visible = true
		debug_ui.process_mode = Node.PROCESS_MODE_INHERIT
	else:
		debug_ui.visible = false
		debug_ui.process_mode = Node.PROCESS_MODE_DISABLED

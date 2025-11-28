extends TextureRect

var is_open : bool

func _ready() -> void:
	is_open = false
	visible = false

func open():
	is_open = true
	visible = true
	process_mode = Node.PROCESS_MODE_INHERIT
	globals.ui_manager.take_control(self)

func close():
	is_open = false
	visible = false
	process_mode = Node.PROCESS_MODE_DISABLED
	globals.ui_manager.release_control()

func handle_input():
	if Input.is_action_just_pressed("camera_ui"):
		if is_open:
			close()
		else:
			open()
	print(is_open)
	
	if Input.is_action_just_pressed("escape"):
		close()

extends Control

class_name UIPuzzle

func open():
	visible = true
	process_mode = Node.PROCESS_MODE_INHERIT

func close():
	visible = false
	process_mode = Node.PROCESS_MODE_DISABLED

func handle_input():
	if Input.is_action_just_pressed("escape"):
		close()

extends Control

class_name UIPuzzle

func open():
	#print("open")
	visible = true
	process_mode = Node.PROCESS_MODE_INHERIT
	globals.ui_manager.take_control(self)

func close():
	#print("close")
	visible = false
	process_mode = Node.PROCESS_MODE_DISABLED
	globals.ui_manager.release_control()

func handle_input():
	if Input.is_action_just_pressed("escape"):
		close()

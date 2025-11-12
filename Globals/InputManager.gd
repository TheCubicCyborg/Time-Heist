extends Node

class_name InputManager

enum InputController {UI, GAMEPLAY}

var input_controller = InputController.GAMEPLAY

func _ready():
	pass

func _process(delta):
	pass

func take_control(controller: InputController):
	input_controller = controller

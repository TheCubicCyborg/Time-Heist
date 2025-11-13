extends Node

#CURRENTLY UNUSED !!!!!

class_name InputManager

enum InputController {UI, GAMEPLAY}

var input_controller = InputController.GAMEPLAY

func _ready():
	pass

func _process(_delta):
	pass

func set_control(controller: InputController):
	input_controller = controller

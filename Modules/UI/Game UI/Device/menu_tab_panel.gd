extends Control
class_name MenuTabPanel

@export var main_focus : Control

func select():
	main_focus.grab_focus()

func handle_input(_delta):
	pass

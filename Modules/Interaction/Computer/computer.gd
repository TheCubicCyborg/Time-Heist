extends Node3D
class_name Computer

@export var computer_ui : ComputerUI

func _ready() -> void:
	computer_ui.close()
	
func interact():
	computer_ui.open()
	

extends Node3D
class_name Computer

@export var computer_ui : ComputerUI

func _ready() -> void:
	if not computer_ui:
		push_error("Computer UI not hooked up")
		assert(false)
	computer_ui.close()
	
func interact():
	computer_ui.open()
	

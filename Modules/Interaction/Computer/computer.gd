extends Node3D
class_name Computer

@export var computer_ui : PackedScene

func _ready() -> void:
	if not computer_ui:
		push_error("Computer UI not hooked up")
		#assert(false)
	#computer_ui.close()
	
func interact():
	globals.ui_manager.desktop_viewer.display_desktop(computer_ui)
	

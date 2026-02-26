extends UI
class_name DesktopViewer


func display_desktop(computer_ui : PackedScene):
	var comp_ui = computer_ui.instantiate()
	#if comp_ui is not ComputerUI:
		#push_error("Non computer ui passed to desktop viewer")
	add_child(comp_ui)
	get_child(0).set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	#animation_player.play("open")
	open()

func handle_input(_delta):
	if Input.is_action_just_pressed("escape"):
		if get_child_count() == 0:
			get_child(0).queue_free()
		#animation_player.play("close")
		close()
	

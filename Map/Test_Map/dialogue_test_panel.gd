extends Panel

signal closed_signal


func _on_close_button_button_down() -> void:
	emit_signal("closed_signal")
	hide()

extends Control

func _ready() -> void:
	pass

func _on_play_pressed() -> void:
	SceneManager.change_scene(SceneManager.Scene.TUTORIAL)
	pass

func _on_settings_pressed():
	pass # Replace with function body.

func _on_credits_pressed() -> void:
	pass # Replace with function body.

func _on_quit_pressed():
	get_tree().quit()

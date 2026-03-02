extends Control

func _ready() -> void:
	print("grabbing focus")
	$Play.grab_focus()
	pass

func _on_play_pressed() -> void:
	SceneManager.change_scene(SceneManager.Scene.TUTORIAL)
	pass

func _on_settings_pressed():
	pass # Replace with function body.


func _on_quit_pressed():
	get_tree().quit()

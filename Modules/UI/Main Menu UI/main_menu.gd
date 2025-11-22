extends Control

func _ready() -> void:
	$MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/Play.grab_focus()

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Map/Test_Map/test_map-alex.tscn")
	pass

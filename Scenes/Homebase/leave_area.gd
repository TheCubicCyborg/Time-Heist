extends Node3D

var resource := load("res://Dialogue/homebase_leave.dialogue")
var balloon_scene := "res://Dialogue/balloon.tscn"
var dial_start_loc := "start"
var dialogue_balloon


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.name == "Player":
		dialogue_balloon = DialogueManager.show_dialogue_balloon_scene(balloon_scene, resource, dial_start_loc)

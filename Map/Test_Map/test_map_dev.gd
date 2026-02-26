extends Node2D

var resource := load("res://Dialogue/test.dialogue")
var balloon_scene := "res://Dialogue/balloon.tscn"
var dial_start_loc := "start"
var dialogue_balloon
var special_ui

func _ready() -> void:
	special_ui = $CanvasLayer/Panel
	
	#dialogue_balloon = preload("res://Dialogue/balloon.tscn").instantiate()
	# add_child(dialogue_balloon)
	dialogue_balloon = DialogueManager.show_dialogue_balloon_scene(balloon_scene, resource, dial_start_loc)

	
	# dialogue_balloon = DialogueManager.show_example_dialogue_balloon(resource, "start")

func open_menu() -> void:
	special_ui.show()
	await special_ui.closed_signal

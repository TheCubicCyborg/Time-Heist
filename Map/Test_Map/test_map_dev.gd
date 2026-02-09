extends Node2D

var resource := load("res://Dialogue/test.dialogue")
var dialogue_balloon
var special_ui

func _ready() -> void:
	special_ui = $CanvasLayer/Panel
	dialogue_balloon = DialogueManager.show_example_dialogue_balloon(resource, "start")

func open_menu() -> void:
	special_ui.show()
	await special_ui.closed_signal

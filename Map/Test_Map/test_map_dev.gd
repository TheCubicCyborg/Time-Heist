extends Node2D

var resource := load("res://Dialogue/test.dialogue")

func _ready() -> void:
	DialogueManager.show_example_dialogue_balloon(resource, "start")

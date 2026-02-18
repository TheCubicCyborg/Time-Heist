extends Node3D

var resource := load("res://Dialogue/homebase_friend.dialogue")
var balloon_scene := "res://Dialogue/balloon.tscn"
var dial_start_loc := "start"
var dialogue_balloon

func interact():
	print("Talking to friend")
	show_friend_dialogue()

func show_friend_dialogue() -> void:
	dialogue_balloon = DialogueManager.show_dialogue_balloon_scene(balloon_scene, resource, dial_start_loc)

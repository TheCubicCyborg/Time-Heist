extends Node3D

var has_item : bool
@export var item : Item

func _ready() -> void:
	pass # Replace with function body.

func interact(person : Node):
	if person == globals.player:
		print("Player interact")
	else:
		print("NPC interact")
		

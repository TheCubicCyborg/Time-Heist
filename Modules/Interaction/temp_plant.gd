extends Node3D

var has_item : bool = false
@export var item : PickupItem
var num_interact : int = 0

func _ready() -> void:
	pass # Replace with function body.

func interact(person : Node):
	if person == globals.player:
		print("PLAYER IS INTERACTING")
		player_interact()
	else:
		npc_interact(person)

func player_interact():
	print(has_item)
	if has_item and item:
		print("ADD ITEM")
		globals.collect_item.emit(item)
	pass
	
func npc_interact(person : Node):
	if not has_item and num_interact == 0:
		print("FIRST INTERACT")
		has_item = true
		num_interact += 1
	elif num_interact == 2:
		print("WHY ARE WE IN HERE???")
		if has_item:
			has_item = false
		else:
			person.following_path = 1
	pass

extends Node
class_name Stashable

var has_item : bool
@export var held_item : PickupItem = null : #TIMEVAR
	set(value):
		if globals.time_manager and globals.time_manager.logging:
			globals.time_manager.timelog(self,"held_item",held_item,value)
		held_item = value
		if value:
			has_item = true
		else:
			has_item = false
@export var expected_item : PickupItem

func interact(person : Node):
	if person == globals.player:
		if has_item:
			globals.collect_item.emit(held_item)
			held_item = null
		else:
			if global_inventory.has_item(expected_item):
				globals.remove_item.emit(expected_item)
				held_item = expected_item
			else:
				print("player doesnt have item")
	else:
		if has_item: # NPC interaction is kinda temp rn. NPCs should honestly have an inventory
			held_item = null
		else:
			held_item = expected_item
	pass
	

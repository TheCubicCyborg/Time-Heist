extends Node
class_name Stashable

var has_item : bool
@export var is_locked : bool = false
@export var held_item : PickupItem = null : #TIMEVAR
	set(value):
		print("STASHABLE SET BEING CALLED")
		if globals.time_manager and globals.time_manager.logging:
			globals.time_manager.timelog(self,"held_item",held_item,value)
		held_item = value
		if value:
			has_item = true
		else:
			has_item = false
@export var expected_item : PickupItem

func interact(person : Node):
	print("interacting with stashable")
	if person == globals.player:
		if not is_locked:
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
			print("locked! suckaaaa")
			return
	else:
		print("NPC TOUCHING PLANT")
		if has_item: # NPC interaction is kinda temp rn. NPCs should honestly have an inventory
			held_item = null
		else:
			held_item = expected_item
	pass

func unlock():
	is_locked = false

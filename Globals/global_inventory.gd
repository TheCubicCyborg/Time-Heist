extends Node

var items : Array[PickupItem]

func _ready() -> void:
	globals.connect("collect_item",add_item)
	
func add_item(item:PickupItem):
	items.append(item)

func has_item(item:PickupItem):
	return items.has(item)

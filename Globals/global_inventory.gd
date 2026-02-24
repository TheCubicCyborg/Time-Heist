extends Node
class_name GlobalInventory

var items : Array[PickupItem] : #TIMEVAR
	set(value):
		if globals.time_manager and globals.time_manager.logging:
			print("LOGGING -- items array as ", items, " at time ", globals.time_manager.cur_time)
			globals.time_manager.timelog(self,"items",items,value)
		items = value
		print("ITEMS ARRAY IN SET FUNCTION: ", items)
		globals.update_items.emit()
@export var items_to_start_with : Array[PickupItem] = []
var documents : Array[DocumentInfo]
var clearances : Array[globals.Clearances]
signal update_device_files

func _ready() -> void:
	items = items_to_start_with
	globals.connect("collect_item",add_item)
	globals.connect("remove_item", remove_item)
	globals.connect("added_doc", add_doc)
	globals.connect("collect_clearance", add_clearance)
	
func add_item(item:PickupItem):
	if not has_item(item):
		print("added item to the global inventory: ", item)
		var temp_items = items.duplicate(1)
		temp_items.append(item)
		print("before adding: ", items)
		items = temp_items

func remove_item(item:PickupItem):
	if has_item(item):
		var temp_items = items
		items.erase(item)
		items = temp_items

func has_item(item:PickupItem):
	return items.has(item)

func add_doc(doc:DocumentInfo):
	if not has_doc(doc):
		documents.append(doc)
		emit_signal("update_device_files", doc)
	
func has_doc(doc:DocumentInfo):
	return documents.has(doc)

func add_clearance(clearance:globals.Clearances):
	if not has_clearance(clearance):
		clearances.append(clearance)
	
func has_clearance(clearance:globals.Clearances):
	return clearances.has(clearance)

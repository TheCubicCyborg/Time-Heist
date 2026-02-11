extends Node
class_name GlobalInventory

var items : Array[PickupItem]
var documents : Array[DocumentInfo]
var clearances : Array[globals.Clearances]
signal update_device_files

func _ready() -> void:
	globals.connect("collect_item",add_item)
	globals.connect("added_doc", add_doc)
	globals.connect("collect_clearance", add_clearance)
	
func add_item(item:PickupItem):
	if not has_item(item):
		items.append(item)

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

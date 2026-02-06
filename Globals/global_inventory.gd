extends Node

var items : Array[PickupItem]
var documents : Array[DocumentInfo]
var clearances : Array[globals.Clearances]

func _ready() -> void:
	globals.connect("collect_item",add_item)
	globals.connect("added_doc", add_doc)
	globals.connect("collect_clearance", add_clearance)
	
func add_item(item:PickupItem):
	items.append(item)

func has_item(item:PickupItem):
	return items.has(item)

func add_doc(doc:DocumentInfo):
	documents.append(doc)
	
func has_doc(doc:DocumentInfo):
	return documents.has(doc)

func add_clearance(clearance:globals.Clearances):
	clearances.append(clearance)
	
func has_clearance(clearance:globals.Clearances):
	return clearances.has(clearance)

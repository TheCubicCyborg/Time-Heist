extends MenuTabPanel
class_name InventoryPanel

@onready var inventory: GridContainer = $HBoxContainer/VBoxContainer/GridContainer
@onready var item_info: RichTextLabel = $HBoxContainer/VBoxContainer/Panel/ItemInfo
var inventory_slot : PackedScene = preload("res://Modules/UI/Game UI/Device/inventory_slot.tscn")

var items : Array[PickupItem]

func _ready() -> void:
	globals.connect("collect_item", collect_item)
	pass

func collect_item(item:PickupItem):
	items.append(item)
	var slot = inventory_slot.instantiate()
	inventory.add_child(slot)
	slot.set_data(item)
	slot.mouse_entered.connect(view_info.bind(slot.item))
	slot.mouse_exited.connect(empty_info)

func view_info(item: PickupItem):
	item_info.text = item.description
	
func empty_info():
	item_info.text = ""

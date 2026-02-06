extends MenuTabPanel
class_name InventoryPanel

@onready var inventory_grid: GridContainer = $HBoxContainer/VBoxContainer/GridContainer
@onready var item_info: RichTextLabel = $HBoxContainer/VBoxContainer/Panel/ItemInfo
var inventory_slot : PackedScene = preload("res://Modules/UI/Game UI/Device/Inventory/inventory_slot.tscn")


func _ready() -> void:
	globals.connect("collect_item", collect_item)
	globals.connect("collect_clearance", collect_clearance)

#region items
func collect_item(item:PickupItem):
	print("adding item")
	var slot = inventory_slot.instantiate()
	inventory_grid.add_child(slot)
	slot.set_data(item)
	slot.mouse_entered.connect(view_info.bind(slot.item))
	slot.mouse_exited.connect(empty_info)

func view_info(item: PickupItem):
	item_info.text = item.description
	
func empty_info():
	item_info.text = ""
#endregion

#region clearances
func collect_clearance(clearance : globals.Clearances):
	if clearance == globals.Clearances.Security:
		$HBoxContainer/Inventory/Clearance/Security.show()
	if clearance == globals.Clearances.Lab:
		$HBoxContainer/Inventory/Clearance/Lab.show()
	if clearance == globals.Clearances.Upper_Office:
		$"HBoxContainer/Inventory/Clearance/Upper Office".show()
	if clearance == globals.Clearances.Utility:
		$HBoxContainer/Inventory/Clearance/Utility.show()
#endregion

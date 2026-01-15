extends UI
class_name DeviceMenu

@export var focused_button : Control
@onready var menu_tabs: TabContainer = $MarginContainer/HBoxContainer/TextureRect/MarginContainer/VBoxContainer/MenuTabs

#var tabs : Array[]

func _ready() -> void:
	pass

func open():
	super.open()
	focused_button.grab_focus()
	globals.ui_manager.take_control(self)
	
func close():
	super.close()
	globals.ui_manager.release_control()

func handle_input():
	super.handle_input()
	menu_tabs.handle_input()

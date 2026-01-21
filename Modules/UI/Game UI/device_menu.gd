extends UI
class_name DeviceMenu

@onready var menu_tabs: TabContainer = $MarginContainer/HBoxContainer/TextureRect/MarginContainer/VBoxContainer/MenuTabs
var tabs : Array[MenuTabPanel]
@export var focused_tab : int = 0

#$MarginContainer/HBoxContainer/TextureRect/MarginContainer/VBoxContainer/MenuTabs/DeviceFiles.select() #TEMP!

func _ready() -> void:
	for tab in menu_tabs.get_children():
		tabs.append(tab)
	select_tab(focused_tab)

func open():
	super.open()
	select_tab(focused_tab)

func handle_input():
	super.handle_input()
	if Input.is_action_just_pressed("ui_tab_forward"):
		focused_tab = (focused_tab + 1) % tabs.size()
		select_tab(focused_tab)
	if Input.is_action_just_pressed("ui_tab_backwards"):
		focused_tab = (focused_tab - 1 + tabs.size()) % tabs.size()
		select_tab(focused_tab)
		
func select_tab(selected_tab : int):
	#for tab in tabs:
		#tab.hide()
	tabs[selected_tab].show()
	tabs[selected_tab].select()

extends UI
class_name DeviceMenu

@onready var menu_tabs: TabContainer = $MarginContainer/HBoxContainer/TextureRect/MarginContainer/VBoxContainer/MenuTabs
var tabs : Array[MenuTabPanel]
@export var focused_tab : int = 0

@onready var button_move : AudioStreamPlayer = $ButtonMove
@onready var button_confirm : AudioStreamPlayer = $ButtonConfirm

#$MarginContainer/HBoxContainer/TextureRect/MarginContainer/VBoxContainer/MenuTabs/DeviceFiles.select() #TEMP!

func _ready() -> void:
	setup_button_sounds(self)
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
	button_move.play()

func setup_button_sounds(node: Node) -> void:
	for child in node.get_children():
		if child is BaseButton:
			child.focus_entered.connect(_on_button_focus_entered)
			child.pressed.connect(_on_button_pressed)
		if child.get_child_count() > 0:
			setup_button_sounds(child)

func _on_button_focus_entered() -> void:
	if button_move:
		if button_move.playing:
			button_move.stop()
		button_move.play()
		
func _on_button_pressed() -> void:
	if button_confirm:
		if button_confirm.playing:
			button_confirm.stop()
		button_confirm.play()
	

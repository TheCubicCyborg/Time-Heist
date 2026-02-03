@tool
extends Control
class_name DesktopItem

@onready var icon: TextureRect = $VBoxContainer/Icon
@onready var title: Label = $VBoxContainer/Title
@export var override_icon : Texture
@export var override_title : String

#signal open_app(icon: DesktopItem, app_scene: Control)

enum ItemType {Other, Email, Text, File}

@export var item_type : ItemType:
	set(value):
		item_type = value
		if value == ItemType.Email:
			override_title = "Email" # maybe also set automatic icon
		elif value == ItemType.Text:
			override_title = "Messages"
		elif value == ItemType.File and file:
			override_icon = file.document_image
			override_title = file.title
		else:
			override_title = "Other"
		
@export var file : DocumentInfo:
	set(value):
		if value:
			file = value;
			item_type = ItemType.File
		else:
			file = null
			
		
@export var tab : DesktopTab
var active : bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#if item_type == ItemType.File:
		#icon.texture = file.document_image
		#title.text = file.title
	#overrides
	if override_icon:
		icon.texture = override_icon
	if override_title:
		title.text = override_title
	pass

func _on_mouse_entered() -> void:
	Input.set_custom_mouse_cursor(globals.clicking_cursor)
	pass

func _on_mouse_exited() -> void:
	Input.set_custom_mouse_cursor(globals.normal_cursor)
	pass

func _on_button_pressed() -> void:
	if tab and not active:
		tab.open_tab()

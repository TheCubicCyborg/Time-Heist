extends Control
class_name MenuTabPanel

@export var main_focus : Control

var panels : Array[ScrollContainer] = []

var documents : Array = [preload("res://Assets/UI/Time Travel Menu/Files_Test/person2.png"), preload("res://Assets/UI/Time Travel Menu/Files_Test/person3.png"), preload("res://Assets/UI/Time Travel Menu/Files_Test/person4.png"), preload("res://Assets/UI/Time Travel Menu/Files_Test/person_1.png"), preload("res://Assets/UI/Time Travel Menu/Files_Test/place1.jpg")]

@onready var people: Button = %People
@onready var places: Button = %Places

@onready var person_1: Button = $HBoxContainer/FilesMargin/VBoxContainer/PeopleContainer/Files/Button2
@onready var person_2: Button = $HBoxContainer/FilesMargin/VBoxContainer/PeopleContainer/Files/Button3
@onready var person_3: Button = $HBoxContainer/FilesMargin/VBoxContainer/PeopleContainer/Files/Button4
@onready var person_4: Button = $HBoxContainer/FilesMargin/VBoxContainer/PeopleContainer/Files/Button5

@onready var place_1: Button = $HBoxContainer/FilesMargin/VBoxContainer/PlacesContainer/Files/Button


@onready var doc_viewer = $HBoxContainer/FileMargin/TextureRect

func _ready() -> void:
	panels = [
		%PeopleContainer, %PlacesContainer
	]
	
	people.focus_entered.connect(view_panel.bind(panels[0]))
	places.focus_entered.connect(view_panel.bind(panels[1]))
	
	person_1.focus_entered.connect(view_doc.bind(documents[3]))
	person_2.focus_entered.connect(view_doc.bind(documents[0]))
	person_3.focus_entered.connect(view_doc.bind(documents[1]))
	person_4.focus_entered.connect(view_doc.bind(documents[2]))
	
	place_1.focus_entered.connect(view_doc.bind(documents[4]))
	
	people.grab_focus()
	view_panel(panels[0])
	
func select():
	main_focus.grab_focus()
	
func view_panel(panel_to_view:ScrollContainer):
	for panel in panels:
		panel.hide()
	
	panel_to_view.show()
	
func view_doc(doc_to_view:Texture):
	doc_viewer.texture = doc_to_view
	

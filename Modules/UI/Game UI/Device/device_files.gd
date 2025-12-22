extends MenuTabPanel

var panels : Array[ScrollContainer] = []

var documents : Array = [preload("res://Assets/UI/Time Travel Menu/Files_Test/person2.png"), preload("res://Assets/UI/Time Travel Menu/Files_Test/person3.png"), preload("res://Assets/UI/Time Travel Menu/Files_Test/person4.png"), preload("res://Assets/UI/Time Travel Menu/Files_Test/person_1.png"), preload("res://Assets/UI/Time Travel Menu/Files_Test/place1.jpg")]

@onready var people: Button = %People
@onready var places: Button = %Places
@onready var document_viewer := $MarginContainer/HBoxContainer/SubViewportContainer/SubViewport/DeviceDocumentViewer

@onready var person_1: Button = $MarginContainer/HBoxContainer/VBoxContainer/PeopleContainer/Files/People1
@onready var person_2: Button = $MarginContainer/HBoxContainer/VBoxContainer/PeopleContainer/Files/People2

@onready var place_1: Button = $MarginContainer/HBoxContainer/VBoxContainer/PlacesContainer/Files/Places1


@onready var doc_viewer = $MarginContainer/HBoxContainer/TextureRect

func _ready() -> void:
	panels = [
		%PeopleContainer, %PlacesContainer
	]
	
	$MarginContainer/HBoxContainer/SubViewportContainer/SubViewport.size = $MarginContainer/HBoxContainer/SubViewportContainer.size
	
	people.focus_entered.connect(view_panel.bind(panels[0]))
	places.focus_entered.connect(view_panel.bind(panels[1]))
	
	person_1.focus_entered.connect(view_doc.bind(0))
	person_2.focus_entered.connect(view_doc.bind(1))
	
	place_1.focus_entered.connect(view_doc.bind(1))
	
	people.grab_focus()
	view_panel(panels[0])
	
func view_panel(panel_to_view:ScrollContainer):
	for panel in panels:
		panel.hide()
	
	panel_to_view.show()
	
func view_doc(doc_to_view:int):
	document_viewer.set_document_texture(doc_to_view)
	
#func select()
	

extends Control
class_name MenuTabPanel

@export var main_focus : Control

var panels : Array[ScrollContainer] = []

@onready var people: Button = %People
@onready var places: Button = %Places

func _ready() -> void:
	panels = [
		%PeopleContainer, %PlacesContainer
	]
	
	people.pressed.connect(view_panel.bind(panels[0]))
	places.pressed.connect(view_panel.bind(panels[1]))
	
	people.grab_focus()
	view_panel(panels[0])
	
func select():
	main_focus.grab_focus()
	
func view_panel(panel_to_view:ScrollContainer):
	for panel in panels:
		panel.hide()
	
	panel_to_view.show()

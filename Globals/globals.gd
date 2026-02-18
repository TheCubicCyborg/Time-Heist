class_name Globals extends Node

#Collision Layers:
#1: Player
#2: Interaction
#3: Floor
#4: Walls
#5: Collidable Interaction
#6:
#7:
#8:

enum InputController {UI, GAMEPLAY}
var controller_of_input = InputController.GAMEPLAY

var time_manager: TimeManager
var ui_manager: UI_Manager

var player : Player

var camera : Node3D
var safe_ratio : float = 1

var time_juice : float = 100
var max_time_juice : float = 100
var rewind_drain_per_sec : float = 15
var rewind_charge_per_sec : float = 10

var allow_interact: bool = true

var cameras : Array[SubViewport]

#var collected_documents: Array[DocumentInfo]
#func collect(doc : DocumentInfo):
	#if not doc in collected_documents:
		#collected_documents.append(doc)
		#emit_signal("added_doc", doc)
		
enum Clearances {
	Security,
	Lab,
	Upper_Office,
	Utility,
	Other
}

#region temporary test variables
var player_has_keycard: bool = false
var janitor_has_keycard: bool = false

#endregion

#region ui
var normal_cursor = preload("res://Assets/UI/Computer/Cursor_normal.png")
var clicking_cursor = preload("res://Assets/UI/Computer/Cursor_click.png")
#endregion

func _ready():
	time_manager = preload("res://Modules/TimeTravel/TimeManager.gd").new()
	add_child(time_manager)
	time_juice = 100

func player_caught():
	get_tree().reload_current_scene()
	time_manager.restart_time()
	time_manager.start_time()
	#END GAME MWAHAHA
	pass

#region Signals
signal added_doc(doc : DocumentInfo)
signal collect_item(item : PickupItem)
signal collect_clearance(clearance : Clearances)
signal use_item(item : PickupItem)
#endregion

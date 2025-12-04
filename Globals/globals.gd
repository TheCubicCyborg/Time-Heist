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
var safe_ratio : float

var allow_interact: bool = true

#region temporary test variables
var player_has_keycard: bool = false
var janitor_has_keycard: bool = false

#endregion




func _ready():
	time_manager = preload("res://Modules/TimeTravel/TimeManager.gd").new()
	add_child(time_manager)

func player_caught():
	get_tree().reload_current_scene()
	time_manager.restart_time()
	time_manager.start_time()
	#END GAME MWAHAHA
	pass

#region Signals

#endregion

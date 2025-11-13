class_name Globals extends Node

#Collision Layers:
#1: Player
#2: Interaction
#3: Floor
#4: Walls
#5:
#6:
#7:
#8:

var time_manager: TimeManager
var ui_manager: UI_Manager

var player : Player

var camera : Node3D

var allow_interact: bool = true

func _ready():
	time_manager = preload("res://Modules/TimeTravel/TimeManager.gd").new()
	add_child(time_manager)

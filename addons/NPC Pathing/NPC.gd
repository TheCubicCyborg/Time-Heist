extends Node3D

class_name NPC

@export var path: NPCPath
var time_manager: TimeManager

func _ready():
	time_manager = globals.time_manager

func _process(delta):
	pass

func _physics_process(delta):
	pass

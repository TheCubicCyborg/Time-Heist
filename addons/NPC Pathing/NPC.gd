extends Node3D

class_name NPC

@export var path: NPCPath

#@export var path: NPCPath
var handler: PathHandler

func _ready():
	handler = PathHandler.new().init(self)
	

func _process(_delta):
	handler.process()

func _physics_process(_delta):
	pass

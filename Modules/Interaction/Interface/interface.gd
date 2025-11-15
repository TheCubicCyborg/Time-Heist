class_name Interface extends Node

@export var ui: Control
var open: bool

func _ready():
	ui.close()

func interact():
	ui.open()

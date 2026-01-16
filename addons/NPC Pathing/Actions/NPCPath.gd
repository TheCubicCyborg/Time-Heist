@tool
class_name NPCPath extends Resource

@export var array: Array[NPCAction]

func _init():
	array = [PathStart.new(),PathEnd.new()]

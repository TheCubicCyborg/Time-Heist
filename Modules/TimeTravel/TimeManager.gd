extends Node

class_name TimeManager

var time_stack: Array[TimeDelta] = []
var cur_time: int
var paused: bool



func _ready():
	print("Time Manager Ready!")

func _physics_process(delta):
	if !paused:
		cur_time += delta

func timelog(_var_name:String, _old_value, _new_value):
	var newDelta = TimeDelta.new()
	newDelta.time_stamp = cur_time
	newDelta.var_name = _var_name
	newDelta.old_value = _old_value
	newDelta.new_value = _new_value
	time_stack.append(newDelta)

class TimeDelta:
	var time_stamp:int
	var var_name:String
	var old_value
	var new_value

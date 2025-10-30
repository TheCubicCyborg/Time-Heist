extends Node

class_name TimeManager

var time_stack: Array[TimeDelta] = []
var cur_time: int = 0
var paused: bool = true
var reversing: bool = false



func _ready():
	print("Time Manager Ready!")

func _physics_process(delta):
	if !paused:
		cur_time += delta

func start_time():
	paused = false

func stop_time():
	paused = true

func restart_time():
	paused = true
	cur_time = 0

func timelog(_object: Node,_var_name:String, _old_value, _new_value):
	var newDelta = TimeDelta.new()
	newDelta.object = _object
	newDelta.time_stamp = cur_time
	newDelta.var_name = _var_name
	newDelta.old_value = _old_value
	newDelta.new_value = _new_value
	time_stack.append(newDelta)

func rewind(time_sec:float):
	var goal_time = cur_time - time_sec
	reversing = true
	while(not time_stack.is_empty() and time_stack.back().time_stamp > goal_time):
		undo_delta(time_stack.pop_back())
	reversing = false

func undo_delta(time_delta: TimeDelta):
	pass

class TimeDelta:
	var object: Node
	var time_stamp:int
	var var_name:String
	var old_value
	var new_value

extends Node

class_name TimeManager

var time_stack: Array[TimeDelta] = []
var cur_time: float = 0
var paused: bool = true
var logging: bool = false
var time_multiplier:float = 1


func _ready():
	logging = true
	pass

func _physics_process(delta):
	if !paused:
		cur_time += delta * time_multiplier

func toggle_time():
	paused = not paused

func start_time():
	paused = false

func stop_time():
	paused = true

func restart_time():
	paused = true
	time_stack.clear()
	cur_time = 0

func timelog(_object: Node,_var_name:String, _old_value, _new_value):
	var newDelta = TimeDelta.new()
	newDelta.object = _object
	newDelta.time_stamp = cur_time
	newDelta.var_name = _var_name
	newDelta.old_value = _old_value
	time_stack.append(newDelta)

func rewind(time_sec:float):
	var goal_time = cur_time - time_sec
	if goal_time < 0:
		goal_time = 0

	logging = false
	while(not time_stack.is_empty() and time_stack.back().time_stamp > goal_time):
		time_stack.pop_back().undo_delta()
	logging = true
	cur_time = goal_time

func start_fast_forward(multiplier: float):
	time_multiplier = multiplier

func stop_fast_forward():
	time_multiplier = 1

class TimeDelta:
	var object: Object
	var time_stamp:int
	var var_name:String
	var old_value
	func undo_delta():
		object.set(var_name,old_value)

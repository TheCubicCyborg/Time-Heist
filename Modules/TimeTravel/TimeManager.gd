extends Node

class_name TimeManager

var time_stack: Array[TimeDelta] = []
var cur_time: float = 0
var paused: bool = true
var logging: bool = false
var time_multiplier:float = 1

const FIXED_REWIND_VALUE = 15
const REWIND_MULTIPLIER = 2
const WAIT_MULTIPLIER = 5

signal time_traveled
signal stopped_time_travel

var is_time_traveling = false

func _ready():
	logging = true
	start_time()

func _physics_process(delta):
	if Input.is_action_pressed("rewind"):
		if not globals.player.infinite_juice: #DEBUG dont lose juice if debug mode
			globals.time_juice = maxf(0.0, globals.time_juice - globals.rewind_drain_per_sec * delta)
		if globals.time_juice > 0.0:
			is_time_traveling = true
			rewind(REWIND_MULTIPLIER * delta)
	elif Input.is_action_pressed("wait"):
		cur_time += delta * WAIT_MULTIPLIER
		if is_time_traveling:
			stopped_time_travel.emit()
			is_time_traveling = false
	elif !paused:
		cur_time += delta * time_multiplier
		if is_time_traveling:
			stopped_time_travel.emit()
			is_time_traveling = false

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
	time_traveled.emit()

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

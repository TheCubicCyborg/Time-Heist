class_name PathLine

var start: Vector3:
	set(value):
		start = value
		calculate_values()
var end: Vector3:
	set(value):
		end = value
		calculate_values()
var midpoint: Vector3
var dir_vec: Vector3
var length: float
func _init(_start:Vector3, _end:Vector3):
	start = _start
	end = _end
	calculate_values()
func calculate_values():
	midpoint = (start + end) * 0.5
	dir_vec = end-start
	length = dir_vec.length()
	dir_vec = dir_vec.normalized()
func _to_string():
	return "Start: " + str(start) + ", End: " + str(end)

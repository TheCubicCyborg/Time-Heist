extends Node3D

@export var X_ROTATION : float
@export var CAM_ROT_SPEED : float
var target_rotation : float = 0.0

enum Direction { 
	NORTH = 0,
	WEST,
	SOUTH,
	EAST,
}
#var direction_to_angle = {
	#Direction.NORTH : 0,
	#Direction.WEST : 90,
	#Direction.SOUTH : 180,
	#Direction.EAST : 270
#}
#var current_rotation : Direction = Direction.NORTH
#var destination_rotation : Direction = Direction.NORTH
var destination_rotation : int = 0
var current_rotation : float = rotation_degrees.y

func _ready() -> void:
	rotation_degrees.x = X_ROTATION
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("camera_right"):
		step_rotation(+1)
		test_print()
	if event.is_action_pressed("camera_left"):
		step_rotation(-1)
		test_print()

func step_rotation(change: int):
	destination_rotation = (destination_rotation + change*90)
	#print("HEY", destination_rotation)
	if destination_rotation >= 360:
		destination_rotation %= 360
	elif destination_rotation <= -360:
		destination_rotation = (destination_rotation % 360)

#var elapsed = 0.0
func _process(delta: float) -> void:
	#var start_rotation = 0.0
	#var DDestination_rotation = 90
	#if rotation_degrees.y != float(destination_rotation):
	rotation_degrees.y = lerp(rotation_degrees.y, float(destination_rotation), delta * CAM_ROT_SPEED)
	#elapsed += delta
	pass

func test_print():
	print("Current:",rotation_degrees.y)
	print("Destination:",float(destination_rotation))

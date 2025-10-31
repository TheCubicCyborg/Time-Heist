extends Node3D

@export var X_ROTATION : float = -60
@export var CAM_ROT_SPEED : float = 5
@export var CAMERA_DISTANCE : float = 7

enum Direction { 
	NORTH = 0,
	WEST,
	SOUTH,
	EAST
}

@export var facing_direction : Direction #Starting facing direction
var previous_facing_direction : Direction

var destination_rotation : int
var current_rotation : float

func _ready() -> void:
	globals.camera = self
	
	get_child(0).position.z = CAMERA_DISTANCE
	rotation_degrees.x = X_ROTATION
	
	rotation_degrees.y = facing_direction * 90
	destination_rotation = facing_direction * 90
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("camera_right"):
		step_rotation(-1)
		test_print()
	if event.is_action_pressed("camera_left"):
		step_rotation(+1)
		test_print()

func step_rotation(change: int):
	#For character input remapping
	globals.player.move_component.should_update_map = true
	
	destination_rotation = (destination_rotation + change*90)
	previous_facing_direction = facing_direction
	if change == -1:
		facing_direction = (facing_direction + change + 4) % 4 as Direction
	elif change == 1:
		facing_direction = (facing_direction + change) % 4 as Direction
	

#var elapsed = 0.0
func _process(delta: float) -> void:
	#Centers camera pivot on the parent
	position = globals.player.position
	
	if rotation_degrees.y != float(destination_rotation):
		rotation_degrees.y = lerp(rotation_degrees.y, float(destination_rotation), delta * CAM_ROT_SPEED)
	else:
		rotation_degrees.y = int(rotation_degrees.y) % 360
	pass

func test_print():
	print(facing_direction)

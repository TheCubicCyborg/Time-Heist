@tool
class_name Player2 extends CharacterBody3D

@onready var mesh: Node3D = $Mesh
@onready var camera_pivot: Node3D = $"Camera Pivot"

@export var camera_up: float = 5.798:
	set(value):
		camera_up = value
		if Engine.is_editor_hint():
			$"Camera Pivot/Camera3D".position.y = value
@export var camera_back: float = 1.928:
	set(value):
		camera_back = value
		if Engine.is_editor_hint():
			$"Camera Pivot/Camera3D".position.z = value
@export var camera_angle: float = -50:
	set(value):
		camera_angle = value
		if Engine.is_editor_hint():
			$"Camera Pivot/Camera3D".rotation.x = deg_to_rad(value)

@export var max_speed: float = 0

var camera_locked: bool = true
var crouching: bool = false

func _ready():
	globals.player2 = self

func _process(_delta):
	if not Engine.is_editor_hint():
		if camera_locked:
			mesh.rotation.y = camera_pivot.rotation.y

func pan_camera_horizontally(angle):
	camera_pivot.rotate(Vector3.UP, angle)

func unlock_camera():
	camera_locked = false

func lock_camera():
	camera_locked = true

func toggle_crouch():
	crouching = not crouching

func move(input_vec: Vector2):
	if not input_vec.is_zero_approx():
		pass

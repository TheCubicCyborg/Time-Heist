extends Node3D

@export var CAMERA_ROTATION_X : float = -50
@export var CAM_ROT_SPEED : float = 4
@export var CAMERA_DISTANCE_BACK : float = 3
@export var CAMERA_DISTANCE_UP : float = 3.5
@export var hor_mouse_sens: float = 0.5
@export var ver_mouse_sens: float = 0.5


var destination_rotation : int
var current_rotation : float
@onready var spring_arm := $SpringArm3D
@onready var camera := $SpringArm3D/Camera3D
var current_camera_z : float

@onready var color_rect := $CanvasLayer/ColorRect

func _ready() -> void:
	globals.camera = self
	spring_arm.spring_length = CAMERA_DISTANCE_BACK
	current_camera_z = spring_arm.spring_length
	rotation_degrees.x = CAMERA_ROTATION_X
	position = Vector3(0, CAMERA_DISTANCE_UP, 0)

func _input(_event: InputEvent) -> void:
	if _event is InputEventMouseMotion:
		rotate(Vector3.UP,deg_to_rad(_event.screen_relative.x * hor_mouse_sens))

extends Node3D

@onready var camera: Camera3D = $Camera3D
@onready var document := $Document
@export var rotation_speed := 1.2
@export var camera_move_speed := 0.03
@export var rotation_smoothing := 15.0

var target_rotation: Vector3

func _ready():
	target_rotation = document.rotation
	#document.texture = null

func handle_input(delta): #change to be handle_function()
	var input := Vector2.ZERO

	if Input.is_action_pressed("rotate_document_right"):
		input.x += 1
	if Input.is_action_pressed("rotate_document_left"):
		input.x -= 1
	if Input.is_action_pressed("rotate_document_down"):
		input.y += 1
	if Input.is_action_pressed("rotate_document_up"):
		input.y -= 1

	target_rotation.y += input.x * rotation_speed * delta
	target_rotation.x += input.y * rotation_speed * delta
	target_rotation.y = clamp(target_rotation.y, deg_to_rad(-45), deg_to_rad(45))
	target_rotation.x = clamp(target_rotation.x, deg_to_rad(-45), deg_to_rad(45))

	document.rotation = document.rotation.lerp(
		target_rotation,
		1.0 - exp(-rotation_smoothing * delta)
	)

func handle_fullscreen_input(delta):
	if Input.is_action_pressed("player_left"):
		camera.position.x -= camera_move_speed
	if Input.is_action_pressed("player_right"):
		camera.position.x += camera_move_speed
	camera.position.x = clamp(camera.position.x, -1, 1)
	if Input.is_action_pressed("player_up"):
		camera.position.y += camera_move_speed
	if Input.is_action_pressed("player_down"):
		camera.position.y -= camera_move_speed
	camera.position.y = clamp(camera.position.y, -1, 1)
	
	if Input.is_action_pressed("ui_document_zoom"):
		camera.position.z -= camera_move_speed
	if Input.is_action_pressed("ui_dowcument_zoom_out"):
		camera.position.z += camera_move_speed
	camera.position.z = clamp(camera.position.z, 0, 1.9)

func reset_position():
	camera.position = Vector3(0,0,0.9)
	target_rotation = Vector3(0,0,0)
	
func set_document_texture(document_id : int):
	var document_to_view = document_database.get_document(document_id)
	document.texture = document_to_view.document_image

extends Node3D

@onready var camera: Camera3D = $Camera3D
@onready var document := $Document
@export var rotation_speed := 1.2
@export var camera_move_speed := 0.03
@export var rotation_smoothing := 15.0

var current_z : float #set by the fit camera to document

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

func handle_fullscreen_input(_delta):
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
	camera.position.z = clamp(camera.position.z, current_z - 2, current_z + 2)

func reset_position():
	camera.position = Vector3(0,0,0)
	target_rotation = Vector3(0,0,0)
	fit_camera_to_document()
	print(camera.position.z)
	
func set_document_texture(document_id : int):
	var document_to_view = document_database.get_document(document_id)
	document.texture = document_to_view.document_image
	fit_camera_to_document()
	print(camera.position.z)
	
func fit_camera_to_document() -> void:
	# Get document world size accounting for pixel_size and scale
	if not document.texture:
		return
	var tex_size = document.texture.get_size()
	var world_width = tex_size.x * document.pixel_size * document.scale.x
	var world_height = tex_size.y * document.pixel_size * document.scale.y
	
	var viewport = camera.get_viewport()
	var viewport_aspect = float(viewport.size.x) / float(viewport.size.y)
	var doc_aspect = world_width / world_height

	var fov_rad = deg_to_rad(camera.fov)

	var dist: float
	if doc_aspect > viewport_aspect:
		# Wide document — fit by width
		var half_width = world_width / 2.0
		dist = half_width / (tan(fov_rad / 2.0) * viewport_aspect)
	else:
		# Tall document — fit by height
		var half_height = world_height / 2.0
		dist = half_height / tan(fov_rad / 2.0)

	camera.position.z = dist
	current_z = dist

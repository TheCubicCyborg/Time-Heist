extends Node3D

@onready var document := $Document
@export var rotation_speed := 2.0
@export var rotation_smoothing := 15.0

var target_rotation: Vector3

func _ready():
	target_rotation = document.rotation

func _process(delta): #change to be handle_function()
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

	document.rotation = document.rotation.lerp(
		target_rotation,
		1.0 - exp(-rotation_smoothing * delta)
	)
	
func set_document_texture(document_id : int):
	var document_to_view = document_database.get_document(document_id)
	document.texture = document_to_view.document_image

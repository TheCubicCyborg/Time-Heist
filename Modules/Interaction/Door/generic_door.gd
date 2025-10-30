extends Node3D
class_name Generic_Door

@export var is_open: bool = false
@export var collision_body: StaticBody3D = null
@export var mesh: MeshInstance3D = null

func _ready():
	if is_open:
		open()

func open():
	collision_body.process_mode = Node.PROCESS_MODE_DISABLED
	mesh.visible = false
	is_open = true

func close():
	collision_body.process_mode = Node.PROCESS_MODE_INHERIT
	mesh.visible = true
	is_open = false

func interact():
	if is_open:
		close()
	else:
		open()

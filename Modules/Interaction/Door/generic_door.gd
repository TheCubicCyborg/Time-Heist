extends Node3D
class_name Generic_Door

@export var is_open: bool = false
@export var is_locked: bool = false
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

func lock():
	is_locked = false

func unlock():
	is_locked = true

func toggle_lock():
	is_locked = not is_locked

func interact():
	if is_open:
		close()
		return true
	elif not is_locked:
		open()
		return true
	else:
		return false

extends Node3D
class_name Generic_Door

@export var is_open: bool = false : #TIMEVAR
	set(value):
		if globals.time_manager and globals.time_manager.logging:
			globals.time_manager.timelog(self,"is_open",is_open,value)
		@warning_ignore("standalone_ternary")
		open() if value else close()
		is_open = value
		
@export var is_locked: bool = false : #TIMEVAR
	set(value):
		if globals.time_manager and globals.time_manager.logging:
			globals.time_manager.timelog(self,"is_locked",is_locked,value)
		is_locked = value
@export var collision_body: StaticBody3D = null
@export var mesh: MeshInstance3D = null
@export var animation_player : AnimationPlayer

## animation time in seconds
const COOLDOWN_TIME = 1.25 
var on_cooldown : bool = false

func _ready():
	if is_open:
		open()

func open():
	collision_body.process_mode = Node.PROCESS_MODE_DISABLED
	#mesh.visible = false

func close():
	collision_body.process_mode = Node.PROCESS_MODE_INHERIT
	#mesh.visible = true

func lock():
	is_locked = true

func unlock():
	is_locked = false

func toggle_lock():
	is_locked = not is_locked

func interact():
	if on_cooldown:
		return
		
	on_cooldown = true
	get_tree().create_timer(COOLDOWN_TIME).timeout.connect(func(): on_cooldown = false)
		
	if is_open:
		is_open = false
		animation_player.play("Door_Action_Close")
		return false
	elif not is_locked:
		print('open')
		is_open = true
		animation_player.play("Door_Action_Open")
		return false
	else:
		animation_player.play("Door_Action_Locked")
		return true


func _on_test_puzzle_puzzle_passed():
	pass # Replace with function body.

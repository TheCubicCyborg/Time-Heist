class_name Player
extends CharacterBody3D

@onready
var state_machine = $state_machine
@onready
var move_component = $move_component

@onready var collision := $CollisionShape3D

var previous_direction_facing := Vector3.FORWARD
var direction_facing

# Sneak
@onready var SneakDetect := $SneakDetect

func _ready() -> void:
	globals.player = self
	
	state_machine.init(move_component)
	
	#MOVE
	SneakDetect.head_cast.position.y = collision.shape.height / 4 * 3
	SneakDetect.hip_cast.position.y = collision.shape.height / 4
	
	pass

func _unhandled_input(event: InputEvent) -> void:
	state_machine.handle_input(event)
	#MOVE
	#if event.is_action_pressed("player_crouch") and is_on_floor():
		#crouching = !crouching
	pass

func _physics_process(delta: float) -> void:
	state_machine.handle_physics(delta)
	
func _process(delta: float) -> void:
	#state_machine.handle_frame(delta)
	pass

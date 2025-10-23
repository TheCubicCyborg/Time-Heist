class_name Player
extends CharacterBody3D

@onready
var state_machine = $state_machine

@export var MAX_SPEED = 10
@export var ACCELERATION = 2
@export var FRICTION = 23
@export var JUMP_VELOCITY = 4.5

@onready var body := $fox
@onready var collision := $CollisionShape3D

var face_to_move = {
	0 : ["player_left", "player_right", "player_up", "player_down"],
	1 : ["player_up", "player_down", "player_right", "player_left"],
	2 : ["player_right", "player_left", "player_down", "player_up"],
	3 : ["player_down", "player_up", "player_left", "player_right"],
}
@onready var facing_direction : int = $CameraPivot.facing_direction
var saved_input : Vector2

# Handles mesh rotation
var last_direction := Vector3.FORWARD
@export var rotation_speed : float = 12.0

# STATE
var crouching : bool = false
var sneaking : bool = crouching

# Sneak
@onready var SneakDetect := $SneakDetect

func _ready() -> void:
	#state_machine.init(self)
	#MOVE
	SneakDetect.head_cast.position.y = collision.shape.height / 4 * 3
	SneakDetect.hip_cast.position.y = collision.shape.height / 4
	
	pass

func _unhandled_input(event: InputEvent) -> void:
	#state_machine.handle_input(event)
	#MOVE
	if event.is_action_pressed("player_crouch") and is_on_floor():
		crouching = !crouching

func _physics_process(delta: float) -> void:
	#state_machine.handle_physics(delta)
	#MOVE
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	var input_dir = get_input_dir()
	var direction = get_direction(input_dir)

	# Handle jump.
	if crouching:
		body.position.y = -0.4
		var lerp_weight = delta * (ACCELERATION-1 if direction else FRICTION+20)
		velocity = lerp(velocity, direction * (MAX_SPEED / 2), lerp_weight)
	else:
		body.position.y = 0
		var lerp_weight = delta * (ACCELERATION if direction else FRICTION)
		velocity = lerp(velocity, direction * MAX_SPEED, lerp_weight)
	
	body.rotation.y = lerp_angle(body.rotation.y, atan2(-last_direction.x, -last_direction.z), delta * rotation_speed)

	move_and_slide()
	
#func _process(delta: float) -> void:
	#state_machine.handle_frame(delta)
	
func get_input_dir() -> Vector2:
	# Get input (based on mapping from direction it is facing
	var input_dir := Input.get_vector(face_to_move[facing_direction][0],face_to_move[facing_direction][1],face_to_move[facing_direction][2],face_to_move[facing_direction][3])
	adjust_for_facing(input_dir) # Updates input maping if camera direction changes
	saved_input = input_dir # Stores previous input (for the above function)
	
	return input_dir

func get_direction(input_dir : Vector2) -> Vector3:
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		last_direction = direction
		
	return direction
	
func adjust_for_facing(input_dir : Vector2):
	if input_dir != saved_input and facing_direction != $CameraPivot.facing_direction:
	#if input_dir == Vector2.ZERO and facing_direction != $CameraPivot.facing_direction:
		facing_direction = $CameraPivot.facing_direction

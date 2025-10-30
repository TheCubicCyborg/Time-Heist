class_name Player
extends CharacterBody3D

@onready
var state_machine = $state_machine

@export var MAX_SPEED = 7
@export var ACCELERATION = 4
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
@export var camera : Node3D
@onready var facing_direction : int = camera.facing_direction
var saved_input : Vector2

# Handles mesh rotation
var last_direction := Vector3.FORWARD
var angle_difference : float
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

	if crouching:
		body.position.y = -0.4
		var lerp_weight = delta * (ACCELERATION-1 if input_dir else FRICTION+20)
		velocity = lerp(velocity, direction * (MAX_SPEED / 2), 0)
	else:
		body.position.y = 0
		
		var lerp_weight = delta * ACCELERATION
		#var player_velocity = Vector3.ZERO
		velocity = lerp(velocity, direction * MAX_SPEED, lerp_weight)
		if angle_difference >= 45 and velocity != Vector3.ZERO:
			velocity = Vector3.ZERO
			print("HAPPENED")
		#angle_difference = abs(rad_to_deg(direction.angle_to(last_direction)))
		#velocity = player_velocity
		#print(velocity)
		#var lerp_weight = delta * (ACCELERATION if input_dir else 0)
		#var lerp_weight = delta * ACCELERATION
		#if input_dir == Vector2.ZERO or abs(input_dir.angle_to(saved_input)) >= 45:
			#lerp_weight = 1 #delta * 8
		#velocity = lerp(velocity, direction * MAX_SPEED, lerp_weight)
	
	if input_dir:
		rotation = lerp(rotation, Vector3(direction[0], direction[2], 0), delta * rotation_speed)

	move_and_slide()
	
func _process(delta: float) -> void:
	#state_machine.handle_frame(delta)
	pass
	
func get_input_dir() -> Vector2:
	# Get input (based on mapping from direction it is facing
	var input_dir := Input.get_vector(face_to_move[facing_direction][0],face_to_move[facing_direction][1],face_to_move[facing_direction][2],face_to_move[facing_direction][3])
	adjust_for_facing(input_dir) # Updates input maping if camera direction changes
	saved_input = input_dir # Stores previous input (for the above function)
	
	return input_dir

func get_direction(input_dir : Vector2) -> Vector3:
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	# MOVE IDK LOL
	if direction != last_direction:
		last_direction = direction
		
	return direction
	
func adjust_for_facing(input_dir : Vector2):
	#Only updates when you change the input AND when you change camera direction
	if input_dir != saved_input and facing_direction != camera.facing_direction:
		facing_direction = camera.facing_direction

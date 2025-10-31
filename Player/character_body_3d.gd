class_name Player
extends CharacterBody3D

@onready
var state_machine = $state_machine

@export var MAX_SPEED = 5.0
@export var ACCELERATION = 3
@export var FRICTION = 23

@onready var body := $fox
@onready var collision := $CollisionShape3D

var face_to_move = {
	0 : ["player_left", "player_right", "player_up", "player_down"],
	1 : ["player_up", "player_down", "player_right", "player_left"],
	2 : ["player_right", "player_left", "player_down", "player_up"],
	3 : ["player_down", "player_up", "player_left", "player_right"],
}

var previous_input : Vector2
var input_map
var should_update_map : bool = false

var previous_direction_facing := Vector3.FORWARD
var direction_facing
@export var rotation_speed : float = 12.0

# Sneak
@onready var SneakDetect := $SneakDetect

#TEST
var added_velocity := 0.0

func _ready() -> void:
	globals.player = self
	
	input_map = face_to_move[globals.camera.facing_direction] # Initally set input map
	#state_machine.init(self)
	#MOVE
	SneakDetect.head_cast.position.y = collision.shape.height / 4 * 3
	SneakDetect.hip_cast.position.y = collision.shape.height / 4
	
	pass

func _unhandled_input(event: InputEvent) -> void:
	#state_machine.handle_input(event)
	#MOVE
	#if event.is_action_pressed("player_crouch") and is_on_floor():
		#crouching = !crouching
	pass

func _physics_process(delta: float) -> void:
	#state_machine.handle_physics(delta)
	#MOVE
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	var input_dir = get_input_dir() # Input direction
	direction_facing = -get_global_transform().basis.z # Used for angle difference checker 
	var direction_vector = (direction_facing * Vector3(abs(input_dir.x), 0, abs(input_dir.y))).normalized()
	
	added_velocity = lerp(added_velocity, MAX_SPEED, ACCELERATION * delta)
	velocity = added_velocity * direction_vector
	print(velocity)
	if input_dir == Vector2.ZERO:
		added_velocity = 0.0
	#if rad_to_deg(direction_facing.angle_to(previous_direction_facing)) > 0.05:
		#velocity = Vector3.ZERO
	
	if input_dir:
		rotation.y = lerp_angle(rotation.y, atan2(-input_dir.x, -input_dir.y), delta * rotation_speed)

	move_and_slide()
	
func _process(delta: float) -> void:
	#state_machine.handle_frame(delta)
	pass
	
func get_input_dir() -> Vector2:
	# Get input (based on mapping from direction it is facing)
	var input_dir := Input.get_vector(input_map[0],input_map[1],input_map[2],input_map[3])
	# Update maping (only if should)
	if should_update_map and input_dir != previous_input:
		input_map = face_to_move[globals.camera.facing_direction]
		should_update_map = false
	
	if input_dir != Vector2.ZERO and input_dir != previous_input:
		velocity = Vector3.ZERO
		previous_input = input_dir # Stores previous input (for the above check)
	#print(input_dir)
	return input_dir
	
#func adjust_for_facing(input_dir : Vector2):
	##Only updates when you change the input AND when you change camera direction
	#if input_dir != previous_input:
		#input_map = face_to_move[globals.camera.facing_direction]

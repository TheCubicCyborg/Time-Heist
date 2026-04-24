@tool
class_name Player2 extends CharacterBody3D

@onready var mesh: Node3D = $Mesh
@onready var camera_pivot: Node3D = $"Camera Pivot"
@onready var animation_tree: AnimationTree = $AnimationTree

@export var camera_up: float = 5.798:
	set(value):
		camera_up = value
		if Engine.is_editor_hint():
			$"Camera Pivot/Camera3D".position.y = value
@export var camera_back: float = 1.928:
	set(value):
		camera_back = value
		if Engine.is_editor_hint():
			$"Camera Pivot/Camera3D".position.z = value
@export var camera_angle: float = -50:
	set(value):
		camera_angle = value
		if Engine.is_editor_hint():
			$"Camera Pivot/Camera3D".rotation.x = deg_to_rad(value)

@export var max_walk_speed: float = 2.5
@export var max_run_speed: float = 5
@export var max_crouch_speed: float = 2.2
@export var roll_speed: float = 5
@export var roll_duration: float = 0.4
@export var turn_speed: float = 15.0

var camera_locked: bool = true
var crouching: bool = false
var rolling: bool = false
var roll_timer: float = 0
var walking: bool = false

var player_facing: Vector3 = Vector3.ZERO
var destination_rotation: float

func _ready():
	animation_tree["parameters/RollTimeScale/scale"] = 1.5/roll_duration
	globals.player2 = self
	destination_rotation = mesh.rotation.y

func _process(_delta):
	if not Engine.is_editor_hint():
		#if camera_locked:
			#mesh.rotation.y = camera_pivot.rotation.y
		pass

func pan_camera_horizontally(angle):
	camera_pivot.rotate(Vector3.UP, angle)

func unlock_camera():
	camera_locked = false

func lock_camera():
	camera_locked = true

func toggle_crouch():
	crouching = not crouching
	if crouching:
		#reduce hitbox
		animation_tree["parameters/CrouchBlendSpace/blend_position"] = 1
	else:
		animation_tree["parameters/CrouchBlendSpace/blend_position"] = 0
		pass #return hitbox to normal

func set_walk(val: bool):
	walking = val

func roll():
	if rolling:
		return
	if crouching:
		crouching = false
	rolling = true
	animation_tree["parameters/WalkRollTransition/transition_request"] = "Roll"
	roll_timer = roll_duration
	velocity = player_facing * roll_speed

func move(input_dir: Vector2, delta):
	if input_dir.is_zero_approx() and not rolling:
		velocity = Vector3.ZERO
		animation_tree["parameters/WalkBlendSpace/blend_position"].y = -1
		animation_tree["parameters/CrouchBlendSpace/blend_position"] = 0
	else:
		if rolling:
			roll_timer -= delta
			if roll_timer <= 0:
				roll_timer = 0
				rolling = false
				animation_tree["parameters/WalkRollTransition/transition_request"] = "Movement"
		else:
			var speed: float = max_run_speed
			if walking:
				speed = max_walk_speed
				animation_tree["parameters/WalkBlendSpace/blend_position"].y = 0
				animation_tree["parameters/CrouchBlendSpace/blend_position"] = 1
			elif crouching:
				speed = max_crouch_speed
			else:
				animation_tree["parameters/WalkBlendSpace/blend_position"].y = 1
				animation_tree["parameters/CrouchBlendSpace/blend_position"] = 1
			velocity = (Vector3(input_dir.x, 0, input_dir.y).normalized() * speed).rotated(Vector3.UP,camera_pivot.rotation.y)
			destination_rotation = Vector3.FORWARD.signed_angle_to(velocity, Vector3.UP)
			player_facing = velocity
			player_facing.y = 0
			player_facing = player_facing.normalized()
		if mesh.rotation.y != destination_rotation:
			mesh.rotation.y = lerp_angle(mesh.rotation.y, destination_rotation,0.5)
	move_and_slide()

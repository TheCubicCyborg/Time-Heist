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

enum MoveStates {RUN, WALK, CROUCH, ROLL}
var state: MoveStates = MoveStates.RUN
var state_move: Callable


func _ready():
	pass

func _process(_delta):
	pass

func pan_camera_horizontally(angle):
	camera_pivot.rotate(Vector3.UP, angle)

func unlock_camera():
	camera_locked = false

func lock_camera():
	camera_locked = true

func toggle_crouch(): #input manager interface function
	pass

func set_walk(val: bool): #input manager interface function
	pass

func roll(): #input manager interface function
	pass

func move(input_dir: Vector2, delta): #input manager calls this every physics_process frame with the pertinent input information
	#anything that should happen for all states should go here
	state_move.call(input_dir,delta)
	move_and_slide()

#region run
func run_enter():
	pass

func run_move(input_dir: Vector2, delta):
	pass
#endregion

#region walk
func walk_enter():
	pass

func walk_move(input_dir: Vector2, delta):
	pass
#endregion

#region crouch
func crouch_enter():
	pass

func crouch_move(input_dir: Vector2, delta):
	pass
#endregion

#region roll
func roll_enter():
	pass

func roll_move(input_dir: Vector2, delta):
	pass
#endregion


#var player_facing: Vector3 = Vector3.ZERO
#var destination_rotation: float

	#if input_dir.is_zero_approx() and not rolling:
		#velocity = Vector3.ZERO
		#animation_tree["parameters/WalkBlendSpace/blend_position"].y = -1
		#animation_tree["parameters/CrouchBlendSpace/blend_position"] = 0
		#if crouching:
			#animation_tree["parameters/WalkCrouchBlend/blend_amount"] = 1
		#else:
			#animation_tree["parameters/WalkCrouchBlend/blend_amount"] = 0
	#else:
		#if rolling:
			#roll_timer -= delta
			#if roll_timer <= 0:
				#roll_timer = 0
				#rolling = false
				#animation_tree["parameters/WalkRollTransition/transition_request"] = "Movement"
		#else:
			#var speed: float = max_run_speed
			#if walking:
				#speed = max_walk_speed
				#animation_tree["parameters/WalkBlendSpace/blend_position"].y = 0
				#animation_tree["parameters/WalkCrouchBlend/blend_amount"] = 0
			#elif crouching:
				#speed = max_crouch_speed
				#animation_tree["parameters/WalkCrouchBlend/blend_amount"] = 1
				#animation_tree["parameters/CrouchBlendSpace/blend_position"] = 1
			#else:
				#animation_tree["parameters/WalkBlendSpace/blend_position"].y = 1
				#animation_tree["parameters/WalkCrouchBlend/blend_amount"] = 0
			#velocity = (Vector3(input_dir.x, 0, input_dir.y).normalized() * speed).rotated(Vector3.UP,camera_pivot.rotation.y)
			#destination_rotation = Vector3.FORWARD.signed_angle_to(velocity, Vector3.UP)
			#player_facing = velocity
			#player_facing.y = 0
			#player_facing = player_facing.normalized()
		#if mesh.rotation.y != destination_rotation:
			#mesh.rotation.y = lerp_angle(mesh.rotation.y, destination_rotation,0.5)

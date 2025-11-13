class_name Player
extends CharacterBody3D

@onready
var state_machine = $state_machine
@onready
var input_controller = $input_controller
@onready
var sneak_detect = $SneakDetect

@onready var collision := $CollisionShape3D
@onready var mesh : MeshInstance3D = $PlayerMesh

var previous_input : Vector2
var is_crouching := false

#region Movement Export Variables
var speed : float
var current_max_speed : float
var current_acceleration : float
@export
var rotation_speed : float = 15.0

@export_category("State Speeds")
#region Walking Variables
@export_group("Walking")
@export
var max_speed_walking : float
@export
var acceleration_walking : float
@export
var deceleration_walking : float
#endregion
#region Crouching Variables
@export_group("Crouching")
@export
var max_speed_crouching : float
@export
var acceleration_crouching : float
@export
var deceleration_crouching : float
#endregion
#region Sliding Variables
@export_group("Sliding")
@export
var max_speed_sliding : float
@export
var deceleration_sliding : float
#endregion
#region Dash Variables
@export_group("Dashing")
@export
var instant_speed_dashing : float
@export
var max_speed_dashing : float
@export
var acceleration_dashing : float
@export
var deceleration_dashing : float
#endregion
#endregion

func _ready() -> void:
	globals.player = self
	
	state_machine.init(input_controller)
	
	#MOVE
	sneak_detect.head.position.y = collision.shape.height / 4 * 3
	sneak_detect.hip.position.y = collision.shape.height / 4
	
	pass

func _unhandled_input(event: InputEvent) -> void:
	state_machine.handle_input(event)
	pass

func _physics_process(delta: float) -> void:
	state_machine.handle_physics(delta)
	
func _process(delta: float) -> void:
	state_machine.handle_frame(delta)
	
	var input_dir = input_controller.get_input_direction() # Input direction
	if input_dir:
		rotation.y = lerp_angle(rotation.y, atan2(-input_dir.x, -input_dir.y), delta * input_controller.rotation_speed)
	
func get_direction_facing() -> Vector3:
	return -get_global_transform().basis.z

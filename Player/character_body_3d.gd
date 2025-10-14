extends CharacterBody3D


const MAX_SPEED = 12
const ACCELERATION = 3
const FRICTION = 10
const JUMP_VELOCITY = 4.5


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("player_left", "player_right", "player_up", "player_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	var lerp_weight = delta * (ACCELERATION if direction else FRICTION)
	velocity = lerp(velocity, direction * MAX_SPEED, lerp_weight)

	move_and_slide()

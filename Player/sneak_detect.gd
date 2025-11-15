extends Node3D

@onready var head := $Head
@onready var hip := $Hip

@onready var head_forward := $Head/HeadForward
@onready var head_right := $Head/HeadRight
@onready var head_back := $Head/HeadBack
@onready var head_left := $Head/HeadLeft

@onready var shape_cast := $Head/ShapeCast3D
@export var start_check : float = 0.25 #meters
@export var end_check : float = 1.5 #meters

@onready var hip_forward := $Hip/HipForward
@onready var hip_right := $Hip/HipRight
@onready var hip_back := $Hip/HipBack
@onready var hip_left := $Hip/HipLeft

@onready var head_casts = [head_forward, head_right, head_back, head_left]
@onready var hip_casts = [hip_forward, hip_right, hip_back, hip_left]

var hip_to_head

func _ready() -> void:
	shape_cast.position.z = -end_check
	shape_cast.target_position.z = -start_check
	
	hip_to_head = {
		hip_forward : head_forward,
		hip_right : head_right,
		hip_back : head_back,
		hip_left : head_left,
	}
	pass

func get_sneak_start_point(): #returns < start_point , bool should_crouch >
	var should_crouch = true
	
	if are_rays_colliding(hip_casts):
		#Priotize forward
		if hip_forward.is_colliding(): #is it the forward one?
			if head_forward.is_colliding(): #is the matching head also colliding?
				should_crouch = false
			var closest_collision = hip_forward.get_collision_point()
			closest_collision = Vector3(closest_collision.x,0,closest_collision.z)
			var offset = (closest_collision - globals.player.position).normalized() * globals.player.collision.shape.radius
			var collision_offsetted = closest_collision - offset
			return [collision_offsetted,should_crouch,hip_forward]
		else:
			var closest_collision = abs(hip_forward.target_position + Vector3(50,50,50)) #ensures its farther than any ray
			var closest_ray
			for ray in hip_casts:
				if ray.is_colliding():
					if abs(ray.get_collision_point()) < abs(closest_collision):
						closest_collision = ray.get_collision_point()
						closest_ray = ray
			if closest_ray:
				if hip_to_head[closest_ray].is_colliding():
					should_crouch = false
				return [Vector3(closest_collision.x,0,closest_collision.z),should_crouch,closest_ray]
	else:
		return null
	pass

func are_rays_colliding(rays) -> bool:
	var result = false
	for ray in rays:
		if ray.is_colliding():
			result = true
	return result
	
func are_any_rays_colliding() -> bool:
	var result = false
	for ray in hip_casts:
		if ray.is_colliding():
			result = true
	for ray in head_casts:
		if ray.is_colliding():
			result = true
	return result

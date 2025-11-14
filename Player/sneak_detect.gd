extends Node3D

@onready var head := $Head
@onready var hip := $Hip

@onready var head_forward := $Head/HeadForward
@onready var head_right := $Head/HeadRight
@onready var head_back := $Head/HeadBack
@onready var head_left := $Head/HeadLeft

@onready var hip_forward := $Hip/HipForward
@onready var hip_right := $Hip/HipRight
@onready var hip_back := $Hip/HipBack
@onready var hip_left := $Hip/HipLeft

@onready var head_casts = [head_forward, head_right, head_back, head_left]
@onready var hip_casts = [hip_forward, hip_right, hip_back, hip_left]

var hip_to_head = {
	hip_forward : head_forward,
	hip_right : head_right,
	hip_back : head_back,
	hip_left : head_left
}

func _ready() -> void:
	#add any needed exceptions here
	#for ray in head_casts:
		#ray.add_exception(globals.player_interact)
	#for ray in hip_casts:
		#ray.add_exception(globals.player_interact)
	pass # Replace with function body.


func get_sneak_start_point(): #returns < start_point , bool should_crouch >
	var should_crouch = true

	if are_any_rays_colliding(hip_casts):
		#Priotize forward
		if hip_forward.is_colliding(): #is it the forward one?
			if head_forward.is_colliding(): #is the matching head also colliding?
				should_crouch = false
			return [hip_forward.get_collision_point(),should_crouch]
		else:
			var closest_collision = abs(hip_forward.target_position + Vector3(1,1,1)) #ensures its farther than any ray
			for ray in hip_casts:
				if ray.is_colliding():
					pass
					
		#Now check for the closest point
		
	else:
		return null
	#Send out hip rays
		#if one gets triggered
			#if forward is triggered priorities that
			#else go to closest ray impact
		#else
			#return null
	pass

func are_any_rays_colliding(rays) -> bool:
	var result = false
	for ray in rays:
		if ray.is_colliding():
			result = true
	return result

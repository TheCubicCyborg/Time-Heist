extends MeshInstance3D

func update_beam(start_pos: Vector3, end_pos: Vector3):
	if start_pos.is_equal_approx(end_pos):
		visible = false
		return
	visible = true

	global_position = (start_pos + end_pos) / 2.0

	look_at(end_pos)
	
	rotate_object_local(Vector3.RIGHT, -PI / 2.0)

	var distance = start_pos.distance_to(end_pos)
	scale.y = distance
	
	scale.x = 1.0 
	scale.z = 1.0

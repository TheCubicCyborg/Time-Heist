extends Node3D
class_name Lever

@export var flipped : bool = false:
	set(value):
		if value:
			$MeshInstance3D.mesh.material.albedo_color = Color(0.0, 0.706, 0.0, 1.0)
		else:
			$MeshInstance3D.mesh.material.albedo_color = Color(0.971, 0.326, 0.3, 1.0)
		flipped = value

func interact():
	if flipped:
		flipped = false
	else:
		flipped = true

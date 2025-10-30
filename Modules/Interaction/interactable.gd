extends Area3D
class_name Interactable

@export var mesh: MeshInstance3D = null
@export var interact_object: Node = null
static var outline_material:StandardMaterial3D = preload("res://Assets/Materials/Highlight.tres")

func targetted():
	if mesh:
		highlight()

func untargetted():
	if mesh:
		remove_highlight()

func highlight():
	mesh.material_overlay = outline_material

func remove_highlight():
	mesh.material_overlay = null

func interact():
	interact_object.interact()

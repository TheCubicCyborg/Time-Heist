# my_custom_gizmo_plugin.gd
extends EditorNode3DGizmoPlugin


const NPC = preload("res://Modules/AI/NPC/NPC.gd")
const PathingGizmo = preload("res://addons/NPC Pathing/pathing_gizmo.gd")

func _get_gizmo_name():
	return "NPC Pathing"

func _init():
	create_material("main", Color(1, 0, 0))
	create_handle_material("handles")


func _create_gizmo(node):
	if node is NPC:
		return PathingGizmo.new()
	else:
		return null

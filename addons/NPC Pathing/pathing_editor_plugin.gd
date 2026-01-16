@tool
extends EditorPlugin

const PathingGizmoPlugin = preload("res://addons/NPC Pathing/pathing_gizmo_plugin.gd")
const PathingToolbar = preload("res://addons/NPC Pathing/pathing_toolbar.tscn")

var gizmo_plugin = PathingGizmoPlugin.new()
var toolbar = PathingToolbar.instantiate()

func _process(delta):
	if Engine.is_editor_hint():
		pass

func _enter_tree():
	add_node_3d_gizmo_plugin(gizmo_plugin)

func _exit_tree():
	remove_node_3d_gizmo_plugin(gizmo_plugin)

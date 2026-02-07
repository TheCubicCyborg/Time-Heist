@tool
extends EditorPlugin

const PathingGizmoPlugin = preload("res://addons/NPC Pathing/pathing_gizmo_plugin.gd")
const PathingInspectorPlugin = preload("res://addons/NPC Pathing/Inspector/pathing_inspector_plugin.gd")

var gizmo_plugin = PathingGizmoPlugin.new(get_undo_redo())
var inspector_plugin = PathingInspectorPlugin.new(get_undo_redo())

func _enter_tree():
	add_node_3d_gizmo_plugin(gizmo_plugin)
	add_inspector_plugin(inspector_plugin)

func _exit_tree():
	remove_node_3d_gizmo_plugin(gizmo_plugin)
	remove_inspector_plugin(inspector_plugin)

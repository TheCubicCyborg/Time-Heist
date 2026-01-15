@tool
extends EditorPlugin

const PathingGizmoPlugin = preload("res://addons/NPC Pathing/pathing_gizmo_plugin.gd")
#const PathingInspectorPlugin = preload("res://addons/NPC Pathing/pathing_inspector_plugin.gd")
const PathingToolbar = preload("res://addons/NPC Pathing/pathing_toolbar.tscn")

var gizmo_plugin = PathingGizmoPlugin.new()
var toolbar = PathingToolbar.instantiate()
#var inspector_plugin = PathingInspectorPlugin.new()

func _process(delta):
	if Engine.is_editor_hint():
		pass

func _enter_tree():
	#print(toolbar)
	add_node_3d_gizmo_plugin(gizmo_plugin)
	#add_inspector_plugin(inspector_plugin)
	#print("added")

func _exit_tree():
	remove_node_3d_gizmo_plugin(gizmo_plugin)
	#remove_inspector_plugin(inspector_plugin)
	#print("removed")

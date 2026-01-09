@tool
extends EditorPlugin

const PathingGizmoPlugin = preload("res://addons/NPC Pathing/pathing_gizmo_plugin.gd")
const PathingToolbar = preload("res://addons/NPC Pathing/pathing_toolbar.tscn")

var gizmo_plugin = PathingGizmoPlugin.new()
var toolbar_instance: Control

func _process(delta):
	if Engine.is_editor_hint():
		pass

func _enter_tree():
	add_node_3d_gizmo_plugin(gizmo_plugin)
	toolbar_instance = PathingToolbar.instantiate()
	add_control_to_container(EditorPlugin.CONTAINER_SPATIAL_EDITOR_MENU,toolbar_instance)
	toolbar_instance.visible = false
	print("added")

func _exit_tree():
	remove_control_from_container(EditorPlugin.CONTAINER_SPATIAL_EDITOR_MENU,toolbar_instance)
	toolbar_instance.queue_free()
	remove_node_3d_gizmo_plugin(gizmo_plugin)
	print("removed")

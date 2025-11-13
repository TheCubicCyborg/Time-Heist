# my_custom_gizmo.gd
extends EditorNode3DGizmo


# You can store data in the gizmo itself (more useful when working with handles).
var gizmo_size = 0.0


func _redraw():
	clear()

	var node3d = get_node_3d()

	var lines = PackedVector3Array()

	lines.push_back(Vector3(0, 1, 0))
	lines.push_back(Vector3(gizmo_size, node3d.position.y, 0))

	var handles = PackedVector3Array()

	handles.push_back(Vector3(0, 1, 0))
	handles.push_back(Vector3(gizmo_size, node3d.position.y, 0))

	var material = get_plugin().get_material("main", self)
	add_lines(lines, material, false)

	var handles_material = get_plugin().get_material("handles", self)
	add_handles(handles, handles_material, [])


# You should implement the rest of handle-related callbacks
# (_get_handle_name(), _get_handle_value(), _commit_handle(), ...).

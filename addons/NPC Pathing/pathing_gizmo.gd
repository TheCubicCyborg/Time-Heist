# my_custom_gizmo.gd
extends EditorNode3DGizmo

var wait_mesh = preload("res://addons/NPC Pathing/Meshes/WaitMesh.tres")
var interact_mesh = preload("res://addons/NPC Pathing/Meshes/InteractMesh.tres")

func _redraw():
	print("redrawing")
	clear()
	
	var npc: NPC = get_node_3d()
	var lines = PackedVector3Array()
	var wait_points = PackedVector3Array()
	var interact_points = PackedVector3Array()
	
	var cur_position: Vector3 = Vector3.ZERO
	
	for action:NPCAction in npc.path.array:
		if action is MoveAction:
			cur_position = action.start_position + action.direction * action.speed * (action.end_time-action.start_time)
			lines.push_back(action.start_position)
			lines.push_back(cur_position)
		elif action is TimedAction:
			wait_points.push_back(cur_position + Vector3.UP)
		elif action is InteractAction:
			interact_points.push_back(cur_position)
	
	var line_material = get_plugin().get_material("line", self)
	add_lines(lines, line_material, false)
	
	var wait_material = get_plugin().get_material("wait", self)
	for w in wait_points:
		print("added wait")
		add_mesh(wait_mesh,wait_material,Transform3D(Basis.IDENTITY,w))
	
	var interact_material = get_plugin().get_material("interact", self)
	for i in interact_points:
		add_mesh(interact_mesh,interact_material,Transform3D(Basis.IDENTITY,i))
		print(wait_points)
		print(interact_points)


# You should implement the rest of handle-related callbacks
# (_get_handle_name(), _get_handle_value(), _commit_handle(), ...).

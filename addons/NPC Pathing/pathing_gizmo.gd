# my_custom_gizmo.gd
extends EditorNode3DGizmo

var path_mesh = preload("res://addons/NPC Pathing/Meshes/PathMesh.tres")
var arrow_mesh = preload("res://addons/NPC Pathing/Meshes/ArrowMesh.tres")

var path_vertices: Array[PathVertex] = []
var path_lines: Array[PathLine] = []

var moving_handle_ix: int = -1

var selected_handle_ix: int = -1
var secondary_selected: bool = false

var creating_vertex: bool = false

func _redraw():
	clear()
	if not get_node_3d().path:
		return
	if path_vertices.is_empty() or get_node_3d().path_changed:
		get_node_3d().path_changed = false
		read_from_path()
	
	#get materials
	var line_material = get_plugin().get_material("line", self)
	var handle_material := get_plugin().get_material("handle",self)
	
	#initialize arrays
	var line_handle_positions := PackedVector3Array()
	var vertex_positions := PackedVector3Array()
	
	#add line meshes
	for line in path_lines:
		if line.length != 0:
			var rotation: Vector3 = Vector3(-PI/2,Vector3.FORWARD.signed_angle_to(line.dir_vec,Vector3.UP),0)
			var basis = Basis.from_scale(Vector3(1,line.length/2,1))
			basis = basis.rotated(Vector3.RIGHT, rotation.x)
			basis = basis.rotated(Vector3.UP, rotation.y)
			var transform: Transform3D = Transform3D(basis,line.midpoint)
			line_handle_positions.push_back(line.midpoint)
			add_mesh(path_mesh,line_material,transform)
			add_mesh(arrow_mesh,line_material,Transform3D(Basis.from_euler(rotation),line.end - line.dir_vec.normalized() * 0.3))
	
	for vertex: PathVertex in path_vertices:
		vertex_positions.push_back(vertex.position)
	
	add_handles(vertex_positions,handle_material,PackedInt32Array(),false,false)
	if not path_lines.is_empty():
		add_handles(line_handle_positions,handle_material,PackedInt32Array(),false,true)

func clear_path():
	path_vertices.clear()
	path_lines.clear()

func read_from_path():
	clear_path()
	
	var cur_action_ix: int = 0
	var cur_position: Vector3 = Vector3.ZERO
	
	path_vertices.push_back(PathVertex.new(cur_action_ix,cur_position))
	
	for action in get_node_3d().path.array:
		if action is MoveAction:
			cur_position = action.start_position + action.direction * action.speed * (action.end_time-action.start_time)
			path_lines.push_back(PathLine.new(action.start_position,cur_position))
			path_vertices.push_back(PathVertex.new(cur_action_ix,cur_position))
		else:
			path_vertices.back().actions.push_back(action)
		cur_action_ix += 1

func _begin_handle_action(id, secondary):
	if not secondary:
		if Input.is_key_pressed(KEY_CTRL): #Create new line and vertex forward
			branch_forward(id)
			creating_vertex = true
		elif id == 0:
			moving_handle_ix = -1
			selected_handle_ix = 0
			secondary_selected = false
			return
		elif Input.is_key_pressed(KEY_SHIFT): #Create new line and vertex backward
			branch_backward(id)
			creating_vertex = true
		else:
			moving_handle_ix = id
		selected_handle_ix = moving_handle_ix
		secondary_selected = false
	else:
		selected_handle_ix = id
		secondary_selected = true
	print("notify changed")
	notify_property_list_changed()

func branch_forward(id:int):
	moving_handle_ix = id + 1
	var new_vertex: PathVertex
	if id == path_vertices.size()-1:
		new_vertex = PathVertex.new(get_node_3d().path.array.size(),path_vertices[id].position)
	else:
		new_vertex = PathVertex.new(path_vertices[id+1].action_start_ix,path_vertices[id].position)
	var new_line: PathLine = PathLine.new(path_vertices[id].position,path_vertices[id].position)
	path_vertices.insert(id+1,new_vertex)
	path_lines.insert(id,new_line)

func branch_backward(id:int):
	moving_handle_ix = id
	if id == 0: #Cannot branch backwards off of root.
		return
	var new_vertex: PathVertex = PathVertex.new(path_vertices[id].action_start_ix,path_vertices[id].position)
	var new_line: PathLine = PathLine.new(path_vertices[id].position,path_vertices[id].position)
	path_vertices.insert(id,new_vertex)
	path_lines.insert(id,new_line)

func _set_handle(id, secondary, camera, point):
	if moving_handle_ix == -1:
		return
	var origin = camera.project_ray_origin(point)
	var direction = camera.project_ray_normal(point)
	var plane = Plane(Vector3.UP)
	var position = plane.intersects_ray(origin,direction)
	path_vertices[moving_handle_ix].position = position
	if moving_handle_ix > 0:
		path_lines[moving_handle_ix-1].end = position
	if moving_handle_ix < path_vertices.size()-1:
		path_lines[moving_handle_ix].start = position
	_redraw()

func _commit_handle(id, secondary, restore, cancel):
	if moving_handle_ix == -1:
		return
	var npc: NPC = get_node_3d()
	var moving_vertex = path_vertices[moving_handle_ix]
	
	if creating_vertex: #Created a new vertex
		var new_move_action: MoveAction = MoveAction.new()
		if moving_handle_ix == path_vertices.size()-1:
			new_move_action.start_time = npc.path.array[moving_vertex.action_start_ix].end_time
			new_move_action.end_time = new_move_action.start_time + 5.0
		else:
			var splitting_move_action: MoveAction = npc.path.array[moving_vertex.action_start_ix]
			var break_ratio = path_lines[moving_handle_ix-1].length/(path_lines[moving_handle_ix-1].length + path_lines[moving_handle_ix].length)
			var break_point = splitting_move_action.start_time + (splitting_move_action.end_time-splitting_move_action.start_time) * break_ratio
			new_move_action.start_time = splitting_move_action.start_time
			new_move_action.end_time = break_point
			splitting_move_action.start_time = break_point
		npc.path.array.insert(moving_vertex.action_start_ix,new_move_action)
		for i in range(moving_handle_ix+1,path_vertices.size()):
			path_vertices[i].action_start_ix += 1
	#set move action parameters
	var prev_line = path_lines[moving_handle_ix-1]
	var prev_move_action: MoveAction = npc.path.array[moving_vertex.action_start_ix]
	prev_move_action.start_position = prev_line.start
	prev_move_action.direction = prev_line.dir_vec
	prev_move_action.speed = prev_line.length/(prev_move_action.end_time-prev_move_action.start_time)
	if moving_handle_ix < path_vertices.size()-1: #If there is a line after / Not the last vertex
		var next_vertex = path_vertices[moving_handle_ix+1]
		var next_line = path_lines[moving_handle_ix]
		var next_move_action: MoveAction = npc.path.array[next_vertex.action_start_ix]
		next_move_action.start_position = next_line.start
		next_move_action.direction = next_line.dir_vec
		next_move_action.speed = next_line.length/(next_move_action.end_time-next_move_action.start_time)
	creating_vertex = false
	moving_handle_ix = -1

func _get_handle_name(id, secondary):
	return "Handle " + str(id)

func _get_handle_value(id, secondary):
	return path_vertices[id].position

func _is_handle_highlighted(id, secondary):
	return secondary_selected == secondary and id == selected_handle_ix

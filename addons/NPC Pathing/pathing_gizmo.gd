# my_custom_gizmo.gd
extends EditorNode3DGizmo

var path_mesh = preload("res://addons/NPC Pathing/Meshes/PathMesh.tres")
var arrow_mesh = preload("res://addons/NPC Pathing/Meshes/ArrowMesh.tres")

var path_vertices: Array[PathVertex] = []
var path_lines: Array[PathLine] = []

var moving_handle_ix: int = -1

var selected_handle_ix: int = -1
var secondary_selected: bool = false

func _redraw():
	clear()
	if not get_node_3d().path:
		return
	if path_vertices.is_empty():
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

func read_from_path():
	path_vertices.clear()
	path_lines.clear()
	
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
		elif Input.is_key_pressed(KEY_SHIFT): #Create new line and vertex backward
			branch_backward(id)
		else:
			moving_handle_ix = id
		selected_handle_ix = moving_handle_ix
		secondary_selected = false
		
		if moving_handle_ix == 0: #Can't move the root, must move NPC's transform instead.
			moving_handle_ix = -1
	else:
		selected_handle_ix = id
		secondary_selected = true

func branch_forward(id:int):
	moving_handle_ix = id + 1
	var branching_vertex = path_vertices[id]
	var next_vertex = path_vertices[id+1]
	var new_vertex: PathVertex = PathVertex.new(next_vertex.action_start_ix,branching_vertex.position)
	var new_line: PathLine = PathLine.new(branching_vertex.position,branching_vertex.position)
	path_vertices.insert(id+1,new_vertex)
	path_lines.insert(id,new_line)


func branch_backward(id:int):
	moving_handle_ix = id
	if id == 0: #Cannot branch backwards off of root.
		return
	
	pass

func _set_handle(id, secondary, camera, point):
	#var origin = camera.project_ray_origin(point)
	#var direction = camera.project_ray_normal(point)
	#var plane = Plane(Vector3.UP)
	#var position = plane.intersects_ray(origin,direction)
	#handle_points[moving_handle] = position
	#if moving_handle > 0:
		#lines[moving_handle-1].end = position
	#if moving_handle < handle_points.size()-1:
		#lines[moving_handle].start = position
	_redraw()

func _commit_handle(id, secondary, restore, cancel):
	save_to_path()
	moving_handle_ix = -1

	#var new_move_action = MoveAction.new()
	#new_move_action.speed = 0
	#new_move_action.start_position = new_line.start
	#new_move_action.direction = new_line.dir_vec
	#new_move_action.start_time = get_node_3d().path.array[next_vertex.action_start_ix].start_time
	#new_move_action.end_time = get_node_3d().path.array[next_vertex.action_start_ix].start_time
	#get_node_3d().path.array.insert(next_vertex.action_start_ix,new_move_action)
	#for i in range(id+2,path_vertices.size()):
		#path_vertices[i].action_start_ix += 1


func save_to_path():
	pass

func _get_handle_name(id, secondary):
	return "Handle " + str(id)

func _get_handle_value(id, secondary):
	return path_vertices[id].position

func _is_handle_highlighted(id, secondary):
	return secondary_selected == secondary and id == selected_handle_ix

class PathVertex:
	var action_start_ix: int
	var actions: Array[NPCAction] = []
	var position: Vector3
	func _init(_start_index: int, _position:Vector3):
		action_start_ix = _start_index
		position = _position

class PathLine:
	var start: Vector3
	var end: Vector3
	var midpoint: Vector3
	var dir_vec: Vector3
	var length: float
	func _init(_start:Vector3, _end:Vector3):
		set_values(_start,_end)
	func set_values(_start:Vector3,_end:Vector3):
		start = _start
		end = _end
		midpoint = (start + end) * 0.5
		dir_vec = end-start
		length = dir_vec.length()
		dir_vec = dir_vec.normalized()
	func _to_string():
		return "Start: " + str(start) + ", End: " + str(end)

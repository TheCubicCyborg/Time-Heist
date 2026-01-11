# my_custom_gizmo.gd
extends EditorNode3DGizmo

var wait_mesh = preload("res://addons/NPC Pathing/Meshes/WaitMesh.tres")
var interact_mesh = preload("res://addons/NPC Pathing/Meshes/InteractMesh.tres")
var path_mesh = preload("res://addons/NPC Pathing/Meshes/PathMesh.tres")
var path_vertex_mesh = preload("res://addons/NPC Pathing/Meshes/PathVertexMesh.tres")
var arrow_mesh = preload("res://addons/NPC Pathing/Meshes/ArrowMesh.tres")

var path_vertices: Array[PathVertex] = []
var lines: Array[PathLine] = []

var handle_points = PackedVector3Array()
var moving_handle: int = -1

var selected_handle: int = -1

func _redraw():
	clear()
	if moving_handle < 0:
		var npc: NPC = get_node_3d()
		
		path_vertices.clear()
		path_vertices.push_back(PathVertex.new())
		handle_points.clear()
		lines.clear()
		var cur_vertex: int = 0
		var cur_position: Vector3 = Vector3.ZERO
		
		handle_points.push_back(cur_position)
		for action:NPCAction in npc.path.array:
			if action is MoveAction:
				cur_position = action.start_position + action.direction * action.speed * (action.end_time-action.start_time)
				lines.push_back(PathLine.new(action.start_position,cur_position))
				path_vertices.push_back(PathVertex.new())
				cur_vertex += 1
				handle_points.push_back(cur_position)
			else:
				path_vertices[cur_vertex].actions.push_back(action)
	
	
	var line_material = get_plugin().get_material("line", self)
	add_mesh(path_vertex_mesh,line_material,Transform3D(Basis.IDENTITY,lines[0].start))
	
	for i in range(0,lines.size()):
		var length = lines[i].start.distance_to(lines[i].end)
		if length != 0:
			var rotation: Vector3 = Vector3(-PI/2,Vector3.FORWARD.signed_angle_to(lines[i].end - lines[i].start,Vector3.UP),0)
			var basis = Basis.from_scale(Vector3(1,length/2,1))
			basis = basis.rotated(Vector3.RIGHT, rotation.x)
			basis = basis.rotated(Vector3.UP, rotation.y)
			var midpoint: Vector3 = (lines[i].start + lines[i].end) * 0.5
			var transform: Transform3D = Transform3D(basis,midpoint)
			add_mesh(path_mesh,line_material,transform)
			add_mesh(arrow_mesh,line_material,Transform3D(Basis.from_euler(rotation),midpoint))
			add_mesh(path_vertex_mesh,line_material,Transform3D(Basis.IDENTITY,lines[i].end))
		
	var handle_material := get_plugin().get_material("handles",self)
	add_handles(handle_points,handle_material,PackedInt32Array(),false,false)

func _begin_handle_action(id, secondary):
	if Input.is_key_pressed(KEY_CTRL):
		lines.insert(id,PathLine.new(handle_points[id],handle_points[id]))
		handle_points.insert(id+1,handle_points[id])
		moving_handle = id+1
	elif Input.is_key_pressed(KEY_SHIFT):
		lines.insert(id,PathLine.new(handle_points[id],handle_points[id]))
		handle_points.insert(id,handle_points[id])
		moving_handle = id
	else:
		moving_handle = id
	selected_handle = moving_handle

func _commit_handle(id, secondary, restore, cancel):
	moving_handle = -1

func _commit_subgizmos(ids, restores, cancel):
	pass

func _get_handle_name(id, secondary):
	return "Handle " + str(id)

func _get_handle_value(id, secondary):
	return handle_points[id]

func _get_subgizmo_transform(id):
	pass

func _is_handle_highlighted(id, secondary):
	return id == selected_handle

func _set_handle(id, secondary, camera, point):
	var origin = camera.project_ray_origin(point)
	var direction = camera.project_ray_normal(point)
	var plane = Plane(Vector3.UP)
	var position = plane.intersects_ray(origin,direction)
	handle_points[moving_handle] = position
	if moving_handle > 0:
		lines[moving_handle-1].end = position
	lines[moving_handle].start = position
	_redraw()

func _set_subgizmo_transform(id, transform):
	pass

func _subgizmos_intersect_frustum(camera, frustum):
	pass

func _subgizmos_intersect_ray(camera, point):
	pass

class PathVertex:
	var actions: Array[NPCAction] = []

class PathLine:
	var start: Vector3
	var end: Vector3
	func _init(_start:Vector3, _end:Vector3):
		start = _start
		end = _end
	func _to_string():
		return "Start: " + str(start) + ", End: " + str(end)

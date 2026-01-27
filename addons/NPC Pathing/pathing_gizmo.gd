# my_custom_gizmo.gd
extends EditorNode3DGizmo

var path_mesh = preload("res://addons/NPC Pathing/Meshes/PathMesh.tres")
var arrow_mesh = preload("res://addons/NPC Pathing/Meshes/ArrowMesh.tres")

var moving_vertex: PathVertex
var selected_component: PathComponent

func _redraw():
	var path: NPCPath = get_node_3d().path
	
	clear()
	if not path:
		return
	var line_material = get_plugin().get_material("line", self)
	var handle_material := get_plugin().get_material("handle",self)
	
	var root_array = PackedVector3Array()
	root_array.push_back(path.at(0).position)
	add_handles(root_array,handle_material,PackedInt32Array(),false,true)
	
	var vertex_positions := PackedVector3Array()
	var vertex_ids := PackedInt32Array()
	var line_positions := PackedVector3Array()
	var line_ids := PackedInt32Array()
	
	for i in range(1,path.size()):
		var component = path.at(i)
		if component is PathVertex:
			vertex_positions.push_back(path.at(i).position)
			vertex_ids.push_back(i)
		elif component is PathLine:
			line_positions.push_back(draw_line(component, line_material))
			line_ids.push_back(i)
	
	if vertex_positions.size() > 0:
		if path.loop:
			line_positions.push_back(draw_line(path.at(path.size()-1), line_material))
			line_ids.push_back(path.size()-1)
		add_handles(vertex_positions,handle_material,vertex_ids)
		add_handles(line_positions,handle_material,line_ids)

func draw_line(line: PathLine, line_material):
	var line_vec = line.next_vertex.position - line.prev_vertex.position
	var line_midpoint = (line.next_vertex.position + line.prev_vertex.position) * 0.5
	var rotation: Vector3 = Vector3(-PI/2,Vector3.FORWARD.signed_angle_to(line_vec,Vector3.UP),0)
	var basis = Basis.from_scale(Vector3(1,line_vec.length()/2,1))
	basis = basis.rotated(Vector3.RIGHT, rotation.x)
	basis = basis.rotated(Vector3.UP, rotation.y)
	var transform: Transform3D = Transform3D(basis,line_midpoint)
	add_mesh(path_mesh,line_material,transform)
	add_mesh(arrow_mesh,line_material,Transform3D(Basis.from_euler(rotation),line.next_vertex.position - line_vec.normalized() * 0.3))
	return line_midpoint

func _begin_handle_action(id, secondary):
	var path = get_node_3d().path
	if id % 2 == 0:
		if Input.is_key_pressed(KEY_CTRL): #Create new line and vertex forward
			moving_vertex = path.branch_forward(id)
		elif id == 0:
			select_component(path.at(0))
			return
		elif Input.is_key_pressed(KEY_SHIFT): #Create new line and vertex backward
			moving_vertex = path.branch_backward(id)
		elif Input.is_key_pressed(KEY_ALT):
			path.delete_vertex(id)
			select_component(path.at(id-2))
			_redraw()
			return
		else:
			moving_vertex = path.at(id)
		select_component(moving_vertex)
	else:
		select_component(path.at(id))

func select_component(component: PathComponent):
	selected_component = component
	if component:
		EditorInterface.get_inspector().edit(component)

func _set_handle(id, secondary, camera, point):
	var path: NPCPath = get_node_3d().path
	if moving_vertex:
		var origin = camera.project_ray_origin(point)
		var direction = camera.project_ray_normal(point)
		var plane = Plane(Vector3.UP)
		var position: Vector3 = plane.intersects_ray(origin,direction)
		position = position.snapped(Vector3(1,0,1) * path.snap)
		moving_vertex.position = position
		var prev_vertex: PathVertex = path.at(moving_vertex.id-2)
		var prev_line: PathLine = path.at(moving_vertex.id-1)
		var add_time = (position.distance_to(prev_vertex.position))/prev_line.speed
		moving_vertex.time_start = prev_vertex.time_end + add_time
		moving_vertex.time_end = prev_vertex.time_end + moving_vertex.get_duration() + add_time

func _commit_handle(id, secondary, restore, cancel):
	moving_vertex = null

func _get_handle_name(id, secondary):
	return "Handle " + str(id)

func _get_handle_value(id, secondary):
	if selected_component is PathVertex:
		return selected_component.position
	elif selected_component is PathLine:
		return selected_component.speed

func _is_handle_highlighted(id, secondary):
	return selected_component and id == selected_component.id

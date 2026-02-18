@tool
class_name NPCPath extends Resource

@export var name: String = ""

@export var path_components: Array[PathComponent]:
	set(value):
		path_components = value
		for component in path_components:
			if not component.manual_change.is_connected(component_manually_changed):
				component.manual_change.connect(component_manually_changed)

@export var snap: float = 0.25
@export var loop: bool = false:
	set(value):
		loop = value
		if size() > 1:
			var last_component = at(size()-1)
			if value:
				if last_component is PathVertex:
					updating_path = true
					var loop_line = PathLine.new(at(size()-1),at(0),size(),self)
					loop_line.time_start = loop_line.prev_vertex.time_end
					loop_line.time_end = loop_line.time_start + loop_line.get_length()/loop_line.speed
					loop_line.is_loop_line = true
					path_components.push_back(loop_line)
					updating_path = false
			else:
				if last_component is PathLine:
					path_components.remove_at(size()-1)
			emit_changed()
@export var default_speed: float = 1

var updating_path: bool = false

func _init():
	resource_local_to_scene = true
	path_components.push_back(PathVertex.new(0,self))

func at(ix: int):
	return path_components[ix]

func size():
	return path_components.size()

func get_path_duration():
	if path_components.size() > 0:
		return at(size()-1).time_end
	else:
		return 0

func _shift_time_by_from(amt_shift:float, ix_from: int):
	for i in range(ix_from,size()):
		var cur_component: PathComponent = at(i)
		cur_component.time_start += amt_shift
		cur_component.time_end += amt_shift

func branch_forward(ix: int):
	updating_path = true
	var branch_vertex = at(ix)
	
	var return_vertex = PathVertex.new(ix+2,self)
	return_vertex.position = branch_vertex.position
	return_vertex.time_start = branch_vertex.time_end
	return_vertex.time_end = branch_vertex.time_start
	
	var new_line = PathLine.new(branch_vertex,return_vertex,ix+1,self)
	new_line.time_start = branch_vertex.time_end
	new_line.time_end = branch_vertex.time_end
	
	if ix < size()-1:
		var next_line: PathLine = at(ix+1)
		next_line.prev_vertex = return_vertex
		
	path_components.insert(ix+1,new_line)
	path_components.insert(ix+2,return_vertex)
	for i in range(ix+3,size()):
		path_components[i].id += 2
	if loop and size() % 2 == 1:
		var loop_line = PathLine.new(at(size()-1),at(0),size(),self)
		loop_line.is_loop_line = true
		path_components.push_back(loop_line)
	updating_path = false
	return return_vertex

func branch_backward(ix: int):
	updating_path = true
	var branch_vertex = at(ix)
	
	var return_vertex = PathVertex.new(ix,self)
	return_vertex.position = branch_vertex.position
	return_vertex.time_start = branch_vertex.time_start
	return_vertex.time_end = branch_vertex.time_start
	
	var new_line: PathLine = PathLine.new(return_vertex,branch_vertex,ix+1,self)
	new_line.time_start = branch_vertex.time_start
	new_line.time_end = branch_vertex.time_end
	
	var prev_line: PathLine = at(ix-1)
	prev_line.next_vertex = return_vertex
	
	path_components.insert(ix,return_vertex)
	path_components.insert(ix+1,new_line)
	for i in range(ix+2,size()):
		path_components[i].id += 2
	updating_path = false
	return return_vertex

func redo_branch(vertex: PathVertex, line: PathLine):
	var branch_vert: PathVertex
	path_components.insert(line.id,line)
	path_components.insert(vertex.id,vertex)
	if vertex.id < size()-1:
		var next_line: PathLine = at(vertex.id+1)
		next_line.prev_vertex = vertex
	var time_dif = vertex.get_duration() + line.get_length()/line.speed
	_shift_time_by_from(time_dif,vertex.id+1)

func delete_vertex(ix: int):
	updating_path = true
	var prev_vert: PathVertex = at(ix-2)
	if ix < size()-1: #Internal Vertex
		var next_line: PathLine = at(ix+1)
		next_line.prev_vertex = prev_vert
		next_line.time_start = prev_vert.time_end
		next_line.time_end = next_line.time_start + next_line.get_length()/next_line.speed
		var time_dif = next_line.time_end - next_line.next_vertex.time_start
		_shift_time_by_from(time_dif,ix+2)
		for i in range(next_line.id,size()):
			at(i).id -= 2
	path_components.remove_at(ix)
	path_components.remove_at(ix-1)
	updating_path = false

func commit_vertex(vertex: PathVertex, action: PathingGizmo.GIZMO_ACTION):
	updating_path = true
	var prev_line: PathLine = at(vertex.id-1)
	prev_line.time_end = vertex.time_start
	if vertex.id < size()-1:
		var next_line: PathLine = at(vertex.id+1)
		next_line.time_start = vertex.time_end
		next_line.time_end = next_line.time_start + next_line.get_length()/next_line.speed
		var time_dif = next_line.time_end - next_line.next_vertex.time_start
		_shift_time_by_from(time_dif,vertex.id+2)
	updating_path = false
	#ResourceSaver.save(self,)

func component_manually_changed(component:PathComponent,property_name: String,old: Variant):
	if not updating_path:
		validate_manual_change(component,property_name,old)
		emit_changed()

func validate_manual_change(component: PathComponent, property_name: String, old: Variant):
	updating_path = true
	if component is PathLine:
		match property_name:
			"speed":
				_validate_speed_change(component,old)
			"time_end":
				component.recalculate_speed()
	elif component is PathVertex:
		match property_name:
			"time_start":
				_validate_time_start_change(component,old)
			"time_end":
				_validate_time_end_change(component,old)
			"position":
				_validate_position_change(component,old)
			"vertex_actions":
				_validate_vertex_actions_change(component)
	updating_path = false

func _validate_speed_change(line: PathLine, old: float):
	line.time_end = line.time_start + line.get_length()/line.speed
	var time_dif = line.time_end - line.next_vertex.time_start
	_shift_time_by_from(time_dif,line.id+1)

func _validate_time_start_change(vertex: PathVertex, old: float):
	var value = vertex.time_start
	vertex.time_start = old
	var prev_line: PathLine = at(vertex.id-1)
	var prev_vert: PathVertex = prev_line.prev_vertex
	if value < prev_vert.time_end:
		value = prev_vert.time_end
	prev_line.time_end = value
	prev_line.recalculate_speed()
	var time_dif: float = value - vertex.time_start
	_shift_time_by_from(time_dif,vertex.id)

func _validate_time_end_change(vertex: PathVertex, old: float):
	var time_dif = vertex.time_end - old
	vertex.time_end = old
	var old_start = vertex.time_start
	vertex.time_start = vertex.time_start + time_dif
	_validate_time_start_change(vertex,old_start)

func _validate_position_change(vertex: PathVertex, old: Vector3):
	if vertex.id == 0:
		return
	var prev_line: PathLine = at(vertex.id-1)
	prev_line.time_end = prev_line.time_start + prev_line.get_length()/prev_line.speed
	var time_dif = prev_line.time_end - vertex.time_start
	_shift_time_by_from(time_dif,vertex.id)

func _validate_vertex_actions_change(vertex: PathVertex):
	var old_end = vertex.time_end
	vertex.time_end = vertex.time_start + vertex.get_duration()
	var time_dif = vertex.time_end - old_end
	_shift_time_by_from(time_dif,vertex.id+1)

func _validate_property(property: Dictionary):
	#if property.name == "path_components":
		#property.usage = PROPERTY_USAGE_STORAGE
	pass

@tool
class_name NPCPath extends Resource

@export var path_components: Array[PathComponent]

@export var snap: int = 0
@export var loop: bool = false:
	set(value):
		loop = value
		if size() > 1:
			if value:
				updating_path = true
				var loop_line = PathLine.new(at(size()-1),at(0),size(),self)
				loop_line.time_start = loop_line.prev_vertex.time_end
				loop_line.time_end = loop_line.time_start + loop_line.get_length()/loop_line.speed
				path_components.push_back(loop_line)
				updating_path = false
			else:
				path_components.remove_at(size()-1)
			emit_changed()
@export var default_speed: float = 1

var updating_path: bool = false

func _init():
	path_components.push_back(PathVertex.new(0,self))

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

func delete_vertex(ix: int):
	updating_path = true
	var prev_vert: PathVertex = path_components[ix-2]
	if ix < size()-1:
		var next_line: PathLine = path_components[ix + 1]
		next_line.prev_vertex = prev_vert
	path_components.remove_at(ix)
	path_components.remove_at(ix-1)
	for i in range(ix-1,size()):
		path_components[i].id -= 2
	updating_path = false

func at(ix: int):
	return path_components[ix]

func size():
	return path_components.size()

func component_changed(id_changed:int,property_name: String):
	#print("component changed")
	#print("component id: ", id_changed, " changed ", property_name)
	if not updating_path:
		validate_times(id_changed,property_name)
	emit_changed()

func validate_times(id_changed:int,property_name: String):
	updating_path = true
	if id_changed % 2 == 0: #edited a vertex
		var changed_vert: PathVertex = at(id_changed)
		if property_name == "time_start":
			#print("editing vertex time start")
			if id_changed > 0:
				var prev_vert: PathVertex = at(id_changed-2)
				if prev_vert.time_end > changed_vert.time_start:
					changed_vert.time_start = prev_vert.time_end
				var prev_line: PathLine = at(id_changed-1)
				prev_line.time_end = changed_vert.time_start
				prev_line.recalculate_speed()
			var old_time_end: float = changed_vert.time_end
			changed_vert.time_end = changed_vert.time_start + changed_vert.get_duration()
			shift_time_by_from(changed_vert.time_end-old_time_end,id_changed+1)
		elif property_name == "time_end":
			#print("editing vertex time end")
			var old_time_start = changed_vert.time_start
			changed_vert.time_start = changed_vert.time_end - changed_vert.get_duration()
			if id_changed > 0:
				var prev_vert: PathVertex = at(id_changed-2)
				if prev_vert.time_end > changed_vert.time_start:
					changed_vert.time_start = prev_vert.time_end
				var prev_line: PathLine = at(id_changed-1)
				prev_line.time_end = changed_vert.time_start
				prev_line.recalculate_speed()
			changed_vert.time_end = changed_vert.time_start + changed_vert.get_duration()
			shift_time_by_from(changed_vert.time_start-old_time_start,id_changed+1)
	else: #edited a line
		var changed_line: PathLine = at(id_changed)
		if property_name == "time_start":
			#print("editing line time start")
			var new_time_start: float = changed_line.time_start
			changed_line.time_start = changed_line.prev_vertex.time_end
			changed_line.prev_vertex.time_end = new_time_start
			validate_times(id_changed-1,"time_end")
		elif property_name == "time_end":
			#print("editing line time end")
			if id_changed == size()-1:
				changed_line.recalculate_speed()
			else:
				var new_time_end: float = changed_line.time_end
				changed_line.time_end = changed_line.next_vertex.time_start
				changed_line.next_vertex.time_start = new_time_end
				validate_times(id_changed+1,"time_start")
		elif property_name == "speed":
			#print("editing line speed")
			if id_changed == size()-1:
				changed_line.time_end = changed_line.time_start + changed_line.get_length()/changed_line.speed
			else:
				var duration: float = changed_line.get_length()/changed_line.speed
				changed_line.next_vertex.time_start = changed_line.time_start + duration
				validate_times(id_changed+1,"time_start")
	updating_path = false

func shift_time_by_from(amt_shift:float, ix_from: int):
	#print("shifting by ",amt_shift, " starting at index ", ix_from)
	for i in range(ix_from,size()):
		var cur_component: PathComponent = at(i)
		#print("shifting component: ",cur_component.id)
		cur_component.time_start += amt_shift
		cur_component.time_end += amt_shift
		if cur_component is PathLine:
			cur_component.recalculate_speed()

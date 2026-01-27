@tool
class_name NPCPath extends Resource

@export var path_components: Array[PathComponent]

@export var snap: int = 0
@export var loop: bool = false:
	set(value):
		loop = value
		if value:
			path_components.push_back(PathLine.new(at(size()-1),at(0),size(),self))
		else:
			path_components.remove_at(size()-1)
		emit_changed()
@export var default_speed: float = 1

func _init():
	path_components.push_back(PathVertex.new(0,self))

func branch_forward(ix: int):
	var branch_vertex = at(ix)
	var return_vertex = PathVertex.new(ix+2,self)
	var new_line = PathLine.new(branch_vertex,return_vertex,ix+1,self)
	if ix < size()-1:
		var next_line: PathLine = at(ix+1)
		next_line.prev_vertex = return_vertex
	path_components.insert(ix+1,new_line)
	path_components.insert(ix+2,return_vertex)
	for i in range(ix+3,size()):
		path_components[i].id += 2
	return return_vertex

func branch_backward(ix: int):
	var branch_vertex = at(ix)
	var return_vertex = PathVertex.new(ix,self)
	var new_line: PathLine = PathLine.new(return_vertex,branch_vertex,ix+1,self)
	var prev_line: PathLine = at(ix-1)
	prev_line.next_vertex = return_vertex
	path_components.insert(ix,return_vertex)
	path_components.insert(ix+1,new_line)
	for i in range(ix+2,size()):
		path_components[i].id += 2
	return return_vertex

func delete_vertex(ix: int):
	var prev_vert: PathVertex = path_components[ix-2]
	if ix < size()-1:
		var next_line: PathLine = path_components[ix + 1]
		next_line.prev_vertex = prev_vert
	path_components.remove_at(ix)
	path_components.remove_at(ix-1)
	for i in range(ix-1,size()):
		path_components[i].id -= 2

func at(ix: int):
	return path_components[ix]

func size():
	return path_components.size()

func component_changed(id_changed:int):
	#print("component changed")
	print("component id: ", id_changed, " changed")
	validate_times(id_changed)
	emit_changed()

func validate_times(id_changed:int):
	pass

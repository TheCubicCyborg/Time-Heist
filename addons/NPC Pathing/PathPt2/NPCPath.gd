@tool
class_name NPCPath extends Resource

var path_components: Array[PathComponent]

@export var snap: int = 0
@export var loop: bool = false:
	set(value):
		loop = value
		if value:
			path_components.push_back(PathLine.new(size(),self))
		else:
			path_components.remove_at(size()-1)
		emit_changed()
@export var default_speed: float = 1

func _init():
	path_components.push_back(PathVertex.new(0,self))

func branch_forward(ix: int):
	path_components.insert(ix+1,PathLine.new(ix+1,self))
	var return_vertex = PathVertex.new(ix+2,self)
	path_components.insert(ix+2,return_vertex)
	for i in range(ix+3,size()):
		path_components[i].id += 2
	return return_vertex

func branch_backward(ix: int):
	var return_vertex = PathVertex.new(ix,self)
	path_components.insert(ix,return_vertex)
	path_components.insert(ix+1,PathLine.new(ix+1,self))
	for i in range(ix+2,size()):
		path_components[i].id += 2
	return return_vertex

func at(ix: int):
	return path_components[ix]

func size():
	return path_components.size()

func vertex_changed():
	emit_changed()

@tool
class_name InteractVertexAction extends VertexAction

@export_node_path("Interactable") var interactable: NodePath

signal interact_signal(nodepath: NodePath)

func interact():
	interact_signal.emit(interactable)

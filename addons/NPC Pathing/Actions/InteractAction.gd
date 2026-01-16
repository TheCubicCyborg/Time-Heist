class_name InteractAction extends NPCAction

@export_node_path("Interactable") var interactable: NodePath
var action_completed: bool = false

func interact():
		print("interact with ", interactable)

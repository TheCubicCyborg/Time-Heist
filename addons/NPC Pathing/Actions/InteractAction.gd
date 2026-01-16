class_name InteractAction extends NPCAction

@export_node_path("Interactable") var interactable: NodePath
var action_completed: bool = false

func interact(handler: PathHandler):
		print("interact with ", interactable)

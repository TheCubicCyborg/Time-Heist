@tool
class_name InteractAction extends InstantAction

@export_node_path var interactable: NodePath

func progress(npc: NPC, from: float, to: float):
	npc.interact_with(interactable)
	return true

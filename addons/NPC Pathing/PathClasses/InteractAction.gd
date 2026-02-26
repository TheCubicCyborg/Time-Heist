@tool
class_name InteractAction extends InstantAction

@export_node_path("Interactable") var interactable: NodePath:
	set(value):
		if Engine.is_editor_hint():
			interactable = value
		else:
			interactable = value

func progress(npc: NPC, from: float, to: float):
	npc.interact_with(interactable)
	return true

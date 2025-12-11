class_name NPCPath extends Resource

var path: Array[NPCAction] = []

func append_action(action:NPCAction):
	path.append(action)

func insert_action(index:int, action:NPCAction):
	path.insert(index,action)

func remove_action_at(index:int):
	path.remove_at(index)

func remove_action(action:NPCAction):
	path.erase(action)

class InteractAction extends NPCAction:
	var interactable: Interactable

class WaitAction extends NPCAction:
	pass

class MoveAction extends NPCAction:
	var destination: Vector3
	var speed: float

@abstract class NPCAction:
	var start_time: float
	var duration: float

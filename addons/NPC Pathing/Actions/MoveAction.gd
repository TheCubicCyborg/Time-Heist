class_name MoveAction extends TimedAction

@export var speed: float
@export var start_position: Vector3
@export var direction: Vector3

func do_action(handler: PathHandler):
	handler.npc.position = start_position + direction * (handler.time_manager.cur_time - start_time) * speed

class_name PathHandler

var cur_action_idx: int
var cur_action: NPCAction
var time_manager: TimeManager
var path_length: int
var npc

func init(_npc: NPC):
	npc = _npc
	cur_action_idx = 0
	cur_action = npc.path.array[cur_action_idx]
	time_manager = globals.time_manager
	return self

func process():
	if time_manager.cur_time < cur_action.start_time:
		go_to_previous_timed_action()
	elif time_manager.cur_time >= cur_action.end_time:
		go_to_next_timed_action()
	
	if cur_action is TimedAction:
		cur_action.do_action(self)

func go_to_next_timed_action():
	cur_action_idx += 1
	cur_action = npc.path.array[cur_action_idx]
	while not cur_action is TimedAction:
		cur_action.do_action(self)
		cur_action_idx += 1
		cur_action = npc.path.array[cur_action_idx]

func go_to_previous_timed_action():
	cur_action_idx -= 1
	cur_action = npc.path.array[cur_action_idx]
	while not cur_action is TimedAction:
		cur_action_idx -= 1
		cur_action = npc.path.array[cur_action_idx]

@tool
class_name NPC extends Node3D

var prev_paths:Array[String]

var time_manager: TimeManager

var cur_component: PathComponent = null
var cur_action_ix: int = 0
var last_processed_time: float = 0
var reached_path_end: bool = false

@export var path: NPCPath:
	set(value):
		path = value
		update_gizmos()
		if path: 
			path.updating_path = true
			path.path_components[0].position = position
			path.updating_path = false
			if not path.changed.is_connected(update_gizmos):
				path.changed.connect(update_gizmos)

func interact_with(nodepath: NodePath):
	get_node(nodepath).interact()

func _ready():
	if not Engine.is_editor_hint():
		time_manager = globals.time_manager
		if path.size() > 0:
			cur_component = path.at(0)
			if cur_component is PathVertex:
				if cur_component.num_actions() > 0:
					cur_action_ix = 0
		for component: PathComponent in path.path_components:
			if component is PathVertex:
				for action: VertexAction in component.vertex_actions:
					if action is InteractVertexAction:
						action.interact_signal.connect(interact_with)

func _process(_delta):
	if not Engine.is_editor_hint() and path:
		var cur_time = time_manager.cur_time
		if path.loop:
			cur_time = fmod(cur_time,path.get_path_duration())
		if last_processed_time > cur_time: # moved backward in time
			while cur_component.time_start > cur_time:
				if cur_component.id > 0:
					cur_component = path.at(cur_component.id-1)
					if cur_component is PathVertex:
						cur_action_ix = cur_component.num_actions()-1
			if cur_component is PathVertex and cur_component.num_actions() > 0:
				var cur_action = cur_component.action(cur_action_ix)
				while cur_action is InteractVertexAction or (cur_action is WaitVertexAction and cur_action.start_time > cur_time):
					cur_action_ix -= 1
					cur_action = cur_component.action(cur_action_ix)
			elif cur_component is PathLine:
				position = cur_component.get_position_at_time(cur_time)
			if cur_time < cur_component.time_end:
				reached_path_end = false
		elif last_processed_time < cur_time: # moved forward in time
			while not reached_path_end and cur_component.time_end <= cur_time:
				if cur_component is PathVertex:
					while cur_action_ix < cur_component.num_actions():
						var cur_action = cur_component.action(cur_action_ix)
						if cur_action is InteractVertexAction:
							cur_action.interact()
						cur_action_ix += 1
				if cur_component.id < path.size()-1:
					cur_action_ix = 0
					cur_component = path.at(cur_component.id+1)
				else:
					reached_path_end = true
			if not reached_path_end:
				if cur_component is PathVertex:
					var cur_action = cur_component.action(cur_action_ix)
					while cur_action is InteractVertexAction or (cur_action is WaitVertexAction and cur_action.end_time <= cur_time):
						if cur_action is InteractVertexAction:
							cur_action.interact()
						cur_action_ix += 1
						cur_action = cur_component.action(cur_action_ix)
				elif cur_component is PathLine:
					position = cur_component.get_position_at_time(cur_time)
		else: #time did not move?
			pass
		last_processed_time = cur_time

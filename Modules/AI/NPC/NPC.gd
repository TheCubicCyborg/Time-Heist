@tool
class_name NPC extends Node3D

@export var color : Color = Color(1.0, 1.0, 1.0, 1.0):
	set(value):
		color = value
		$MeshInstance3D.mesh.material.albedo_color = value

@export var branch_paths: Array[NPCPath] = []
@export var follow_branch: int = -1:
	set(value):
		if value < branch_paths.size():
			follow_branch = value
			if not Engine.is_editor_hint():
				path_following = branch_paths[value]
				initialize_path_vars()
var path_following: NPCPath = null

var time_manager: TimeManager

var cur_component: PathComponent = null
var cur_action_ix: int = 0
var last_processed_time: float = 0
var reached_path_end: bool = false

var start_pos: Vector3


@export_category("Path Editor")
@export var path: NPCPath:
	set(value):
		path = value
		if Engine.is_editor_hint():
			update_gizmos()
			if path: 
				path.updating_path = true
				var first_vert_pos = position
				first_vert_pos.y = 0
				path.path_components[0].position = first_vert_pos
				path.updating_path = false
				if not path.changed.is_connected(update_gizmos):
					path.changed.connect(update_gizmos)


func interact_with(nodepath: NodePath):
	get_node(nodepath).interact()

func _ready():
	if not Engine.is_editor_hint():
		time_manager = globals.time_manager
		start_pos = Vector3.UP * position.y
		if follow_branch > -1:
			path_following = branch_paths[follow_branch]
			initialize_path_vars()


func _process(_delta):
	if not Engine.is_editor_hint():
		if not path_following:
			return
		var cur_time = time_manager.cur_time
		if path_following.loop:
			cur_time = fmod(cur_time,path_following.get_path_duration())
		if last_processed_time > cur_time: # moved backward in time
			while cur_component.time_start > cur_time:
				if cur_component.id > 0:
					cur_component = path_following.at(cur_component.id-1)
					if cur_component is PathVertex:
						cur_action_ix = cur_component.num_actions()-1
			if cur_component is PathVertex and cur_component.num_actions() > 0:
				var cur_action = cur_component.action(cur_action_ix)
				while cur_action is InteractVertexAction or (cur_action is WaitVertexAction and cur_action.start_time > cur_time):
					cur_action_ix -= 1
					cur_action = cur_component.action(cur_action_ix)
			elif cur_component is PathLine:
				position = cur_component.get_position_at_time(cur_time) + start_pos
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
				if cur_component.id < path_following.size()-1:
					cur_action_ix = 0
					cur_component = path_following.at(cur_component.id+1)
				else:
					reached_path_end = true
			if not reached_path_end:
				if cur_component is PathVertex:
					var cur_action = cur_component.action(cur_action_ix)
					while cur_action != null and cur_action_ix < cur_component.num_actions() and (cur_action is InteractVertexAction or (cur_action is WaitVertexAction and cur_action.end_time <= cur_time)):
						if cur_action is InteractVertexAction:
							cur_action.interact()
						cur_action = cur_component.action(cur_action_ix)
						cur_action_ix += 1
				elif cur_component is PathLine:
					#print("pos from path:",cur_component.get_position_at_time(cur_time), " start y: ", start_y)
					position = cur_component.get_position_at_time(cur_time) + start_pos
		else: #time did not move?
			pass
		last_processed_time = cur_time


func initialize_path_vars():
	if path_following.size() > 0:
		cur_component = path_following.at(0)
		if cur_component is PathVertex:
			if cur_component.num_actions() > 0:
				cur_action_ix = 0
	for component: PathComponent in path_following.path_components:
		if component is PathVertex:
			for action: VertexAction in component.vertex_actions:
				if action is InteractVertexAction:
					action.interact_signal.connect(interact_with)

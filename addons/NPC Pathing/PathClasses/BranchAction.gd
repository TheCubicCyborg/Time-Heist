class_name BranchAction extends InstantAction

@export_node_path() var object: NodePath
@export var property_name: String = ""
@export var is_false: bool = false
@export var dest_path_id: int
@export var start_branch_at_cur_time: bool = false

func progress(npc: NPC, from: float, to: float):
	var branched = npc.branch_if(self)
	if branched:
		return false
	return true

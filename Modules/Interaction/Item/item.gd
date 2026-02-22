@tool
extends Node3D

class_name Item

@export var item: PickupItem:
	set(value):
		$MeshInstance3D.mesh = null
		if value:
			$MeshInstance3D.mesh = value.mesh
		item = value;

var picked_up : bool : #TIMEVAR
	set(value):
		if globals.time_manager and globals.time_manager.logging:
			globals.time_manager.timelog(self,"picked_up",picked_up,value)
		picked_up = value
		hide() if value else show()

func interact():
	picked_up = true
	globals.emit_signal("collect_item", item)
	#TEMP
	globals.emit_signal("collect_clearance", globals.Clearances.Security)

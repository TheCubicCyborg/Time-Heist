@tool
extends Node3D

class_name Item

@export var item: PickupItem:
	set(value):
		$MeshInstance3D.mesh = null
		if value:
			$MeshInstance3D.mesh = value.mesh
		item = value;

func interact():
	queue_free()
	globals.emit_signal("collect_item", item)
	#TEMP
	globals.emit_signal("collect_clearance", globals.Clearances.Security)

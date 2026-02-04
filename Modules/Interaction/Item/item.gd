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
	globals.emit_signal("collect_item", item)
	queue_free()

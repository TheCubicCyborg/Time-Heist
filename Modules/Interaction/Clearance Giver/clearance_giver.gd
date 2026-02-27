extends Node3D

@export var clearance_type : globals.Clearances

func interact():
	globals.collect_clearance.emit(clearance_type)
	pass

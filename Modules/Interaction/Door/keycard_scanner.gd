extends Node3D
class_name KeycardScanner

signal keycard_scanned
var display_note: bool = false
var display_time_elapsed: float = 0
@export var needed_item: Array[PickupItem]
@export var consume_items: bool = false
@export var needed_clearance: Array[globals.Clearances]
@export var needed_doc: Array[DocumentInfo]
@export var needed_lever: Array[Lever]
@export var locked_label : String

@export var is_unlocked: bool = false : #TIMEVAR
	set(value):
		if globals.time_manager and globals.time_manager.logging:
			globals.time_manager.timelog(self,"is_unlocked",is_unlocked,value)
		if value:
			$MeshInstance3D.mesh.material.albedo_color = Color(0.0, 0.706, 0.0, 1.0)
		else:
			$MeshInstance3D.mesh.material.albedo_color = Color("ee4243")
		is_unlocked = value

#var success = preload("res://Assets/Materials/Interactable/success.tres")

func _ready() -> void:
	$MeshInstance3D.mesh.material.albedo_color = Color("ee4243")
	$Label.text = locked_label

func interact():
	var unlocked = check_interact()
	
	if not unlocked:
		is_unlocked = false
		display_note = true
		$Label.visible = true
		return
	else:
		is_unlocked = true
		keycard_scanned.emit()
		is_unlocked = true

func check_interact():
	var success = true
	if needed_doc:
		for doc in needed_doc:
			if not global_inventory.has_doc(doc):
				success = false
	if needed_item:
		for item in needed_item:
			if not global_inventory.has_item(item):
				success = false
			elif consume_items:
				global_inventory.remove_item(item)
	if needed_clearance:
		for clearance in needed_clearance:
			if not global_inventory.has_clearance(clearance):
				success = false
	if needed_lever:
		for lever in needed_lever:
			if not lever.flipped:
				success= false
	return success

func _process(delta):
	if display_note:
		if display_time_elapsed >= 2:
			display_note = false
			display_time_elapsed = 0
			$Label.visible = false
		else:
			display_time_elapsed += delta

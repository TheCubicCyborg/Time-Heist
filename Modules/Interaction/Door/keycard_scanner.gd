extends Node3D
class_name KeycardScanner

signal keycard_scanned
var display_note: bool = false
var display_time_elapsed: float = 0
@export var needed_item: Array[PickupItem]
@export var needed_clearance: Array
@export var locked_label : String

#var success = preload("res://Assets/Materials/Interactable/success.tres")

func _ready() -> void:
	$Label.text = locked_label

func interact():
	if needed_item:
		for item in needed_item:
			if not global_inventory.has_item(item):
				display_note = true
				$Label.visible = true
				return
		keycard_scanned.emit()
		$MeshInstance3D.mesh.material.albedo_color = Color(0.0, 0.706, 0.0, 1.0)
func _process(delta):
	if display_note:
		if display_time_elapsed >= 2:
			display_note = false
			display_time_elapsed = 0
			$Label.visible = false
		else:
			display_time_elapsed += delta

extends Control
class_name HUD

@onready var time_juice: TextureProgressBar = $TimeJuice

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	time_juice.value = globals.time_juice
	pass

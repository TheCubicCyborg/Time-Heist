extends Light3D
class_name OfficeLight

var energy_on
var energy_off := 0.0
var target_energy = energy_off

static var fade_speed := 5


func _ready() -> void:
	energy_on = light_energy
	pass

func off():
	target_energy = energy_off

func on():
	target_energy = energy_on

func _process(delta: float) -> void:
	light_energy = lerpf(light_energy, target_energy, fade_speed * delta)

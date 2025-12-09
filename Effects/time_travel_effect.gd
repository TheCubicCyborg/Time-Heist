extends ColorRect

@export var duration : float = 2.0
var is_playing_effect = false

func _ready() -> void:
	globals.time_manager.time_traveled.connect(_play_anim)

func _play_anim() -> void:
	if is_playing_effect:
		return
	is_playing_effect = true
	var tween : Tween = create_tween()
	tween.tween_method(_set_shader_radius, 0.0, 1.0, duration)
	await tween.finished
	_set_shader_radius(0.0)
	is_playing_effect = false
	
func _set_shader_radius(value: float) -> void:
	var mat : ShaderMaterial = material
	mat.set_shader_parameter('radius', value)

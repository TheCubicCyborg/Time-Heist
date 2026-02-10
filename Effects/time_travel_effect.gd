extends ColorRect

@export var duration : float = 1.0
var is_playing_effect = false

func _ready() -> void:
	globals.time_manager.time_traveled.connect(_play_anim)
	globals.time_manager.stopped_time_travel.connect(func(): is_playing_effect = false)

func _play_anim() -> void:
	if is_playing_effect:
		return
	is_playing_effect = true
	var tween : Tween = create_tween()
	tween.tween_method(_set_shader_radius, 0.0, 0.8, duration)
	await tween.finished
	
	while is_playing_effect:
		await _pulsate_effect()

func _pulsate_effect() -> void:
	var tween : Tween = create_tween()
	tween.tween_method(_set_shader_radius, 0.8, 0.3, duration / 2)
	tween.tween_method(_set_shader_radius, 0.3, 0.8, duration / 2)
	await tween.finished
	
func _set_shader_radius(value: float) -> void:
	var mat : ShaderMaterial = material
	mat.set_shader_parameter('radius', value)

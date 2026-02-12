extends ColorRect

@export var duration : float = 0.2
var is_playing_effect = false
@export var subviewport_container : SubViewportContainer

@onready var time_travel_post_fx = preload("res://Effects/time_travel_post_fx.tres")

func _ready() -> void:
	globals.time_manager.time_traveled.connect(_play_anim)
	globals.time_manager.stopped_time_travel.connect(func(): is_playing_effect = false)
	visible = false

func _play_anim() -> void:
	if is_playing_effect:
		return
	is_playing_effect = true
	visible = true
	#var old_mat = null
	#if subviewport_container:
		#old_mat = subviewport_container.material
		#subviewport_container.material = time_travel_post_fx
	
	var tween : Tween = create_tween()
	tween.tween_method(_set_shader_radius, 0.0, 0.6, duration)
	await tween.finished
	
	while is_playing_effect:
		await _pulsate_effect()
	
	var tween1 : Tween = create_tween()	
	tween1.tween_method(_set_shader_radius, 0.6, 0.0, duration)
	#if subviewport_container:
		#subviewport_container.material = old_mat
	visible = false
		
	

func _pulsate_effect() -> void:
	var tween : Tween = create_tween()
	tween.tween_method(_set_shader_radius, 0.6, 0.58, 0.02)
	tween.tween_method(_set_shader_radius, 0.58, 0.6, 0.02)
	await tween.finished
	
func _set_shader_radius(value: float) -> void:
	var mat : ShaderMaterial = material
	mat.set_shader_parameter('intensity', value)

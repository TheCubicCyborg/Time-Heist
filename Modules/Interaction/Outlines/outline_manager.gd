class_name OutlineManager extends Control

@export var main_camera: Camera3D

@export_group("Outline Colors")
@export var default_color: Color = Color(0.4, 0.4, 0.0, 1.0)
@export var targeted_color: Color = Color(1.0, 1.0, 0.0, 1.0)
@export var disabled_color: Color = Color(1.0, 0.0, 0.0, 1.0)

@export_group("Outline Settings")
@export var outline_width: int = 5

var sv_default: SubViewport
var sv_targeted: SubViewport
var sv_disabled: SubViewport

var sv_camera_default: Camera3D
var sv_camera_targeted: Camera3D
var sv_camera_disabled: Camera3D

var compositor_effect: OutlineCompositorEffect

func _ready() -> void:
	process_priority = 500
	await get_tree().process_frame
	await get_tree().process_frame
	call_deferred("_setup")

func _setup() -> void:
	sv_default  = _create_sub_viewport(2)
	sv_targeted = _create_sub_viewport(4)
	sv_disabled = _create_sub_viewport(8)

	sv_camera_default  = _create_sv_camera(sv_default,  2)
	sv_camera_targeted = _create_sv_camera(sv_targeted, 4)
	sv_camera_disabled = _create_sv_camera(sv_disabled, 8)

	await RenderingServer.frame_post_draw
	await RenderingServer.frame_post_draw

	compositor_effect = OutlineCompositorEffect.new()
	compositor_effect.outline_width = outline_width
	compositor_effect.default_color = default_color
	compositor_effect.targeted_color = targeted_color
	compositor_effect.disabled_color = disabled_color
	compositor_effect.sv_texture_default  = sv_default.get_texture()
	compositor_effect.sv_texture_targeted = sv_targeted.get_texture()
	compositor_effect.sv_texture_disabled = sv_disabled.get_texture()

	var main_compositor := Compositor.new()
	main_compositor.compositor_effects = [compositor_effect]
	main_camera.compositor = main_compositor

func _create_sub_viewport(cull_mask: int) -> SubViewport:
	var container := SubViewportContainer.new()
	container.visible = false
	container.size = get_viewport().size
	container.stretch = true
	add_child(container)

	var sv := SubViewport.new()
	sv.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	sv.transparent_bg = true
	sv.own_world_3d = false
	container.add_child(sv)
	sv.world_3d = get_viewport().world_3d
	return sv

func _create_sv_camera(sv: SubViewport, cull_mask: int) -> Camera3D:
	var cam := Camera3D.new()
	cam.cull_mask = cull_mask
	var encode_effect := EncodeDepthEffect.new()
	var compositor := Compositor.new()
	compositor.compositor_effects = [encode_effect]
	cam.compositor = compositor

	sv.add_child(cam)
	return cam

func _process(_delta: float) -> void:
	if not is_instance_valid(main_camera):
		return
	_sync_camera(sv_camera_default)
	_sync_camera(sv_camera_targeted)
	_sync_camera(sv_camera_disabled)

func _sync_camera(cam: Camera3D) -> void:
	if not is_instance_valid(cam):
		return
	cam.global_transform = main_camera.get_camera_transform()
	cam.fov = main_camera.fov
	cam.near = main_camera.near
	cam.far = main_camera.far
	cam.projection = main_camera.projection
	cam.keep_aspect = main_camera.keep_aspect

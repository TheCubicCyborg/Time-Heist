class_name OutlineManager extends Control

@export var main_camera: Camera3D
@export var compositor_effect: OutlineCompositorEffect

var sub_viewport: SubViewport
var sv_camera: Camera3D
var container: SubViewportContainer

func _ready() -> void:
	process_priority = 500
	await get_tree().process_frame
	await get_tree().process_frame
	call_deferred("_setup_sub_viewport")

func _setup_sub_viewport() -> void:
	container = SubViewportContainer.new()
	container.visible = false
	container.size = get_viewport().size
	container.stretch = true
	add_child(container)

	sub_viewport = SubViewport.new()
	sub_viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	sub_viewport.transparent_bg = true
	container.add_child(sub_viewport)

	sub_viewport.own_world_3d = false
	sub_viewport.world_3d = get_viewport().world_3d

	sv_camera = Camera3D.new()
	sv_camera.cull_mask = 2

	var encode_effect := EncodeDepthEffect.new()
	var compositor := Compositor.new()
	compositor.compositor_effects = [encode_effect]
	sv_camera.compositor = compositor

	sub_viewport.add_child(sv_camera)

	await RenderingServer.frame_post_draw
	await RenderingServer.frame_post_draw

	var main_compositor := Compositor.new()
	main_compositor.compositor_effects = [compositor_effect]
	main_camera.compositor = main_compositor

	compositor_effect.sv_viewport_texture = sub_viewport.get_texture()

func _process(_delta: float) -> void:
	if not is_instance_valid(main_camera) or not is_instance_valid(sv_camera):
		return
	sv_camera.global_transform = main_camera.get_camera_transform()
	sv_camera.fov = main_camera.fov
	sv_camera.near = main_camera.near
	sv_camera.far = main_camera.far
	sv_camera.projection = main_camera.projection
	sv_camera.keep_aspect = main_camera.keep_aspect

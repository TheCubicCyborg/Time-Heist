class_name EncodeDepthEffect extends CompositorEffect

var rd: RenderingDevice
var shader: RID
var pipeline: RID

func _init() -> void:
	effect_callback_type = EFFECT_CALLBACK_TYPE_POST_TRANSPARENT
	rd = RenderingServer.get_rendering_device()
	RenderingServer.call_on_render_thread(_initialize_compute)

func _notification(what: int) -> void:
	if what == NOTIFICATION_PREDELETE:
		if shader.is_valid():
			RenderingServer.free_rid(shader)

func _initialize_compute() -> void:
	rd = RenderingServer.get_rendering_device()
	if not rd:
		return
	var shader_file := load("res://Modules/Interaction/Outlines/encode_depth.glsl")
	var shader_spirv: RDShaderSPIRV = shader_file.get_spirv()
	shader = rd.shader_create_from_spirv(shader_spirv)
	if shader.is_valid():
		pipeline = rd.compute_pipeline_create(shader)

func _render_callback(_p_effect_callback_type: EffectCallbackType, p_render_data: RenderData) -> void:
	if not rd or not pipeline.is_valid():
		return

	var render_scene_buffers := p_render_data.get_render_scene_buffers() as RenderSceneBuffersRD
	if not render_scene_buffers:
		return

	var size: Vector2i = render_scene_buffers.get_internal_size()
	if size.x == 0 or size.y == 0:
		return

	@warning_ignore("integer_division")
	var x_groups := (size.x - 1) / 8 + 1
	@warning_ignore("integer_division")
	var y_groups := (size.y - 1) / 8 + 1

	var push_constant := PackedFloat32Array([
		size.x, size.y,
		0.0, 0.0
	])

	var view_count := render_scene_buffers.get_view_count()
	for view in view_count:
		var color_image: RID = render_scene_buffers.get_color_layer(view)
		var depth_image: RID = render_scene_buffers.get_depth_layer(view)

		var u_color := RDUniform.new()
		u_color.uniform_type = RenderingDevice.UNIFORM_TYPE_IMAGE
		u_color.binding = 0
		u_color.add_id(color_image)

		var sampler_state := RDSamplerState.new()
		var sampler := rd.sampler_create(sampler_state)
		var u_depth := RDUniform.new()
		u_depth.uniform_type = RenderingDevice.UNIFORM_TYPE_SAMPLER_WITH_TEXTURE
		u_depth.binding = 1
		u_depth.add_id(sampler)
		u_depth.add_id(depth_image)

		var uniform_set := UniformSetCacheRD.get_cache(shader, 0, [u_color, u_depth])

		var compute_list := rd.compute_list_begin()
		rd.compute_list_bind_compute_pipeline(compute_list, pipeline)
		rd.compute_list_bind_uniform_set(compute_list, uniform_set, 0)
		rd.compute_list_set_push_constant(compute_list, push_constant.to_byte_array(), push_constant.size() * 4)
		rd.compute_list_dispatch(compute_list, x_groups, y_groups, 1)
		rd.compute_list_end()

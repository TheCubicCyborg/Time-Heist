#[compute]
#version 450

layout(local_size_x = 8, local_size_y = 8, local_size_z = 1) in;

layout(rgba8, set = 0, binding = 0) uniform restrict writeonly image2D color_image;
layout(set = 0, binding = 1) uniform sampler2D depth_image;

layout(push_constant, std430) uniform Params {
	vec2 raster_size;
	vec2 reserved;
} params;

// encode_depth.glsl
vec3 srgb_to_linear(vec3 sRGB) {
	bvec3 cutoff = lessThan(sRGB, vec3(0.04045));
	vec3 higher = pow((sRGB + vec3(0.055)) / vec3(1.055), vec3(2.4));
	vec3 lower = sRGB / vec3(12.92);
	return mix(higher, lower, cutoff);
}

void main() {
	ivec2 uv = ivec2(gl_GlobalInvocationID.xy);
	ivec2 size = ivec2(params.raster_size);
	if (uv.x >= size.x || uv.y >= size.y) return;

	float depth = texelFetch(depth_image, uv, 0).r;

	uint float_bits = floatBitsToUint(depth);
	vec4 encoded = vec4(
		float((float_bits & 0xFF000000u) >> 24u) / 255.0,
		float((float_bits & 0x00FF0000u) >> 16u) / 255.0,
		float((float_bits & 0x0000FF00u) >>  8u) / 255.0,
		float( float_bits & 0x000000FFu       ) / 255.0
	);

	// Pre-correct for sRGB conversion that will be applied to the viewport color buffer
	encoded.rgb = srgb_to_linear(encoded.rgb);

	imageStore(color_image, uv, encoded);
}

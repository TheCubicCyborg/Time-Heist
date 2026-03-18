#[compute]
#version 450

layout(local_size_x = 8, local_size_y = 8, local_size_z = 1) in;

layout(rgba16f, set = 0, binding = 0) uniform restrict image2D color_image;
layout(set = 1, binding = 0) uniform sampler2D depth_image;
layout(set = 2, binding = 0) uniform sampler2D sv_depth_encoded;

layout(push_constant, std430) uniform Params {
	vec2 image_size;
	float outline_width;
	float reserved;
	vec4 outline_color;
} params;

float decode_depth(vec4 encoded) {
	uvec4 bits = uvec4(round(encoded * 255.0));
	uint float_bits = (bits.x << 24u) | (bits.y << 16u) | (bits.z << 8u) | bits.w;
	return uintBitsToFloat(float_bits);
}

bool is_opaque(vec2 uv) {
	if (uv.x < 0.0 || uv.x > 1.0 || uv.y < 0.0 || uv.y > 1.0) return false;
	ivec2 texel = ivec2(uv * params.image_size);
	float depth = decode_depth(texelFetch(sv_depth_encoded, texel, 0));
	return depth > 0.0 && depth < 0.9999;
}

void main() {
	ivec2 uv = ivec2(gl_GlobalInvocationID.xy);
	if (uv.x >= int(params.image_size.x) || uv.y >= int(params.image_size.y)) return;

	vec2 screen_uv = vec2(uv) / params.image_size;

	if (is_opaque(screen_uv)) return;

	vec2 pixel_size = vec2(1.0) / params.image_size;
	vec2 neighbor_uv = screen_uv;
	float closest_dist = 999999.0;
	bool has_opaque_neighbor = false;

	for (float x = -params.outline_width; x <= params.outline_width; x++) {
		for (float y = -params.outline_width; y <= params.outline_width; y++) {
			if (x == 0.0 && y == 0.0) continue;
			float dist = length(vec2(x, y));
			if (dist > params.outline_width) continue;
			vec2 sample_uv = screen_uv + vec2(x, y) * pixel_size;
			if (is_opaque(sample_uv)) {
				has_opaque_neighbor = true;
				if (dist < closest_dist) {
					closest_dist = dist;
					neighbor_uv = sample_uv;
				}
			}
		}
	}

	if (!has_opaque_neighbor) return;

	// Sample scene depth at the outline pixel (outside the silhouette)
	float scene_depth = texelFetch(depth_image, uv, 0).r;

	// Sample interactable depth at the nearest silhouette pixel
	float interactable_depth = decode_depth(texelFetch(sv_depth_encoded, ivec2(neighbor_uv * params.image_size), 0));

	// Suppress outline if scene has something in front of the interactable (occluded)
	// Tolerance scales with depth to handle non-linear depth buffer
	float tolerance = interactable_depth * 0.0001;
	if (scene_depth > interactable_depth + tolerance) return;

	imageStore(color_image, uv, params.outline_color);
}

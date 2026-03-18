shader_type spatial;
render_mode unshaded, cull_front;

uniform sampler2D depth_texture : hint_depth_texture, filter_nearest;
uniform float depth_tolerance = 0.1;

void vertex() {
	vec3 object_origin = MODEL_MATRIX[3].xyz;
	VERTEX = VERTEX * 1.2;
	// Called for every vertex the material is visible on.
}

float linearize_depth(float depth, mat4 proj) {
    return proj[3][2] / (depth + proj[2][2]);
}

//void fragment() {
	//float scene_linear = linearize_depth(texture(depth_texture,UV).r, PROJECTION_MATRIX);
	//float fragment_linear = linearize_depth(FRAGCOORD.z, PROJECTION_MATRIX);
	//
	//if (scene_linear < fragment_linear - depth_tolerance) {
		//discard;
	//}
//}

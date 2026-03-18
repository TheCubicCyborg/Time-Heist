shader_type spatial;
render_mode unshaded, cull_disabled, depth_draw_always;

uniform sampler2D texture_albedo : source_color;
uniform float alpha_threshold : hint_range(0.0, 1.0) = 0.1;

void fragment() {
    vec4 tex = texture(texture_albedo, UV);
    if (tex.a < alpha_threshold) {
        discard;
    }
    ALBEDO = vec3(1.0);
    ALPHA = 1.0;
}
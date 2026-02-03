shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_nearest;

// The number of "pixels" of color that it is quantized into.
uniform vec2 screen_res = vec2(800.0, 450.0); 
uniform float color_levels = 16.0;

void fragment() {
    vec2 uv = floor(SCREEN_UV * screen_res) / screen_res;
    
    vec3 original_color = texture(SCREEN_TEXTURE, uv).rgb;
    
    float luma = dot(original_color, vec3(0.299, 0.587, 0.114));
    float bucketed_luma = floor(luma * color_levels) / color_levels;

    vec3 final_color = original_color * (bucketed_luma / max(luma, 0.001));
    //vec3 final_color = floor(original_color * color_levels) / color_levels;
	
    COLOR = vec4(final_color, 1.0);
}
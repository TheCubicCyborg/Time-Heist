shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_nearest;

// The number of "pixels" of color that it is quantized into.
uniform vec2 screen_res = vec2(800.0, 450.0); 
uniform float color_levels = 8.0;
uniform float dither_strength = 4;

void fragment() {
    vec2 uv = floor(SCREEN_UV * screen_res) / screen_res;
    vec3 original_color = texture(SCREEN_TEXTURE, uv).rgb;
	
	ivec2 uv_pixels = ivec2(uv * screen_res);
    int x = uv_pixels.x % 4;
    int y = uv_pixels.y % 4;
	
	float bayer_matrix[16] = float[](
        0.0, 8.0, 2.0, 10.0,
        12.0, 4.0, 14.0, 6.0,
        3.0, 11.0, 1.0, 9.0,
        15.0, 7.0, 13.0, 5.0
    );
	
	float band_size = 1.0 / color_levels;
	
	float dither_shift = (bayer_matrix[y * 4 + x] / 16.0) - 0.5;
	original_color += dither_shift * (band_size * dither_strength);
    
    float luma = dot(original_color, vec3(0.299, 0.587, 0.114));
    float bucketed_luma = floor(luma * color_levels) / color_levels;

    vec3 final_color = original_color * (bucketed_luma / max(luma, 0.001));
    //vec3 final_color = floor(original_color * color_levels) / color_levels;
	
    COLOR = vec4(final_color, 1.0);
}
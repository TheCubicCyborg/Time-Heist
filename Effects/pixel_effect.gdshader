shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_nearest;

// The number of horizontal "pixels" of color that it is quantized into.
uniform float num_horizontal_chunks = 800.0; 

void fragment() {
    vec2 uv = SCREEN_UV;
    uv = floor(uv * num_horizontal_chunks) / num_horizontal_chunks;
    vec3 pixelated_color = texture(SCREEN_TEXTURE, uv).rgb;
    COLOR = vec4(pixelated_color, 1.0);
}
shader_type spatial;
render_mode unshaded, cull_disabled;
uniform sampler2D sprite_texture : source_color;
uniform vec4 outline_color : source_color;
uniform float outline_width = 0.05;

void vertex(){
	VERTEX *= 1.0 + outline_width;
}

void fragment() {
	vec2 uv_remapped = (UV - 0.5) * (1.0 + outline_width) + 0.5;
	if (!(uv_remapped.x < 0.0 || uv_remapped.x > 1.0 || uv_remapped.y < 0.0 || uv_remapped.y > 1.0))
	{
		if (texture(sprite_texture,uv_remapped).a > 0.2)
		{
			discard;
		}
	}
	if (texture(sprite_texture,UV).a < 0.2)
	{
		discard;
	}
	ALBEDO = outline_color.rgb;
	ALPHA = outline_color.a;
}
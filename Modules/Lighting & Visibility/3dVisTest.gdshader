shader_type spatial;

uniform sampler2D albedo_texture : source_color;

void fragment() {
	vec4 text = texture(albedo_texture,UV);
	if (text.r > 0.0 && text.g > 0.0 && text.b > 0.0)
	{
		ALPHA = 0.0;
	}
	else
	{
		ALBEDO = text.rgb;
		ALPHA = text.a;
	}
}
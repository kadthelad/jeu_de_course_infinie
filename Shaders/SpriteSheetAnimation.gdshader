shader_type spatial;

uniform sampler2D albedo_texture : source_color, filter_nearest_mipmap;
uniform int columns = 1;
uniform int rows = 1;
uniform int frame = 0;

void fragment() {
	// UV Animation Logic
	vec2 frame_size = vec2(1.0 / float(columns), 1.0 / float(rows));
	vec2 frame_uv = vec2(
		float(frame % columns) * frame_size.x,
		float(frame / columns) * frame_size.y
	);
	
	vec2 final_uv = frame_uv + (UV * frame_size);
	vec4 tex = texture(albedo_texture, final_uv);
	
	ALBEDO = tex.rgb;
	ALPHA = tex.a;
	
	// Alpha Scissor
	if (ALPHA < 0.1) discard;
}
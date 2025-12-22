shader_type spatial;
// cull_disabled allows seeing the sprite from behind
// depth_prepass_alpha helps with transparency sorting
render_mode blend_mix, depth_draw_always, cull_disabled;

uniform sampler2D albedo_texture : source_color, filter_nearest_mipmap;
uniform int columns = 1;
uniform int rows = 1;
uniform int frame = 0;

void vertex() {
	// Billboard logic: Always face camera
	MODELVIEW_MATRIX = VIEW_MATRIX * mat4(
		vec4(normalize(MODEL_MATRIX[0].xyz), 0.0),
		vec4(normalize(MODEL_MATRIX[1].xyz), 0.0),
		vec4(normalize(MODEL_MATRIX[2].xyz), 0.0),
		MODEL_MATRIX[3]
	);
}

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
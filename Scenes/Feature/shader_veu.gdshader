shader_type canvas_item;

uniform float time_scale = 1.0;
uniform float wave_strength = 5.0;
uniform float wave_frequency = 20.0;
uniform lowp vec4 modulate_color : source_color = vec4(0.12, 0.0, 0.2, 1.0);

void fragment() {
	vec2 uv = FRAGCOORD.xy / vec2(1280.0, 720.0); // Ajuste para sua resolução

	// Aplica distorção de onda
	uv.y += (sin(uv.x * wave_frequency + TIME * time_scale) * wave_strength) / 100.0;
	uv.x += (cos(uv.y * wave_frequency + TIME * time_scale) * wave_strength) / 100.0;

	COLOR = modulate_color;
}

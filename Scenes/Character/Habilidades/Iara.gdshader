shader_type canvas_item;

uniform vec4 key_color = vec4(1.0, 0.0, 0.0, 1.0); // Cor do fundo a remover (vermelho)
uniform float tolerance = 1.0;

void fragment() {
	vec4 tex_color = texture(TEXTURE, UV);
	float diff = distance(tex_color.rgb, key_color.rgb);

	if (diff < tolerance) {
		discard; // Remove o pixel
	}

	COLOR = tex_color;
}

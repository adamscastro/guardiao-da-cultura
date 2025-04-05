shader_type canvas_item;

uniform vec4 color_to_remove;  // Define a cor a ser removida
uniform float tolerance = 0.1; // Ajuste a tolerância da cor

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);
    if (distance(tex_color.rgb, color_to_remove.rgb) < tolerance) {
        tex_color.a = 0.0;  // Torna a cor transparente
    }
    COLOR = tex_color;
}

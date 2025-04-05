shader_type canvas_item;

uniform float effect_strength : hint_range(0.0, 1.0) = 1.0;

void fragment() {
    vec4 color = texture(TEXTURE, UV);
    float grayscale = (color.r + color.g + color.b) / 3.0; // Converte para escala de cinza
    vec3 veil_color = vec3(0.5, 0.0, 0.5); // Roxo
    vec3 final_color = mix(vec3(grayscale), veil_color, effect_strength); // Mistura cor original e véu
    COLOR = vec4(final_color, color.a);
}

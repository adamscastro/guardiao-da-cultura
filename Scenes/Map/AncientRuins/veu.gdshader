shader_type canvas_item;

uniform float time_scale = 1.5;
uniform float wave_strength = 2.0;
uniform float wave_frequency = 18.0;
uniform float pulse_speed = 2.0;
uniform float pulse_intensity = 0.05;
uniform float chromatic_aberration_strength = 0.003;
uniform float color_shift_speed = 0.5;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;

void fragment() {
    // Em vez de SCREEN_UV, usa FRAGCOORD normalizado
    vec2 uv = (FRAGCOORD.xy / vec2(1280.0, 720.0)); // Ajuste para sua resolução!

    // Distorsão sem depender do movimento de câmera
    uv.y += sin(uv.x * wave_frequency + TIME * time_scale) * wave_strength / 200.0;
    uv.x += cos(uv.y * wave_frequency + TIME * time_scale) * wave_strength / 200.0;

    // Aberração cromática
    vec2 aberration = vec2(
        sin(TIME * 2.0) * chromatic_aberration_strength,
        cos(TIME * 2.0) * chromatic_aberration_strength
    );

    vec4 tex_r = texture(SCREEN_TEXTURE, SCREEN_UV + aberration);
    vec4 tex_g = texture(SCREEN_TEXTURE, SCREEN_UV);
    vec4 tex_b = texture(SCREEN_TEXTURE, SCREEN_UV - aberration);

    vec4 distorted_color = vec4(tex_r.r, tex_g.g, tex_b.b, tex_g.a);

    // Pulso no alpha
    float pulse = (sin(TIME * pulse_speed) * 0.5 + 0.5) * pulse_intensity;

    // Variação de cor
    vec4 final_color = COLOR;
    final_color.r += sin(TIME * color_shift_speed) * 0.05;
    final_color.g += sin(TIME * color_shift_speed * 0.8) * 0.05;
    final_color.b += sin(TIME * color_shift_speed * 1.2) * 0.05;
    final_color.a -= pulse;

    COLOR = distorted_color * final_color;
}

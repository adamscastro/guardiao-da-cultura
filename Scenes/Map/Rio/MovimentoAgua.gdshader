shader_type canvas_item;

uniform float strength : hint_range(0.0, 0.1) = 0.005;           // Velocidade horizontal da correnteza
uniform float wave_height : hint_range(0.0, 0.01) = 0.0015;       // Altura da ondulação vertical
uniform float wave_freq : hint_range(1.0, 20.0) = 5.0;            // Frequência da ondulação
uniform float glow_intensity : hint_range(0.0, 1.0) = 0.1;        // Intensidade do brilho etéreo
uniform vec3 glow_color : source_color = vec3(0.6, 0.9, 1.0);     // Cor do brilho (ciano mágico)

void fragment() {
    vec2 uv = UV;

    // Movimento da correnteza + ondulação sutil
    uv.x += TIME * strength;
    uv.y += sin((UV.x + TIME) * wave_freq) * wave_height;

    vec4 tex = texture(TEXTURE, uv);

    // Brilho etéreo suave, pulsando lentamente
    float glow = sin(TIME * 2.0) * 0.5 + 0.5; // varia de 0 a 1
    tex.rgb += glow * glow_intensity * glow_color;

    COLOR = tex;
}

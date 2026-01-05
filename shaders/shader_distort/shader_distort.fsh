// shader_distort.fsh
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform sampler2D distortion_texture_page; // sampler que vamos setar
uniform float intensity; // opcional: controla força global

void main()
{
    vec2 distort_amount = vec2((v_vColour * texture2D(distortion_texture_page, v_vTexcoord)).xy);

    // Ajuste para normal map-like (flip green)
    distort_amount.x = 1.0 - distort_amount.x;

    // centraliza em 0
    distort_amount -= 0.5;

    // wrap (precaução)
    if (distort_amount.x > 0.5) { distort_amount.x -= 1.0; }
    if (distort_amount.y > 0.5) { distort_amount.y -= 1.0; }

    // intensidade padrão (divide) — controlável por uniform
    float base = 4.0;
    float final_div = base / max(0.0001, intensity); // intensity>1 => mais forte
    distort_amount /= final_div;

    gl_FragColor = v_vColour * texture2D(gm_BaseTexture, v_vTexcoord + distort_amount);
}

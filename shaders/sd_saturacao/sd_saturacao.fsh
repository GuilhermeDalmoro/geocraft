varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float u_saturation; // 1.0 = normal, >1 = mais saturado, <1 = dessaturado

void main() {
    vec4 base_col = texture2D(gm_BaseTexture, v_vTexcoord);
    vec3 gray = vec3(dot(base_col.rgb, vec3(0.299, 0.587, 0.114))); // luminância
    vec3 saturated = mix(gray, base_col.rgb, u_saturation);
    gl_FragColor = vec4(saturated, base_col.a) * v_vColour;
}

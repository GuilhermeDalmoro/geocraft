/// obj_distort_controller Post Draw

if (!global.distort_enabled) {
    // só desenha a application surface normalmente
    draw_surface(application_surface, 0, 0);
    exit;
}

// cria surface do tamanho da room (pode ser app_surface size se preferir)
if (!surface_exists(surface_distort)) {
   surface_distort = surface_create(room_width, room_height);
}

surface_set_target(surface_distort);
// cor neutra (127,127,255) -> sem movimento
var neutral = make_colour_rgb(127,127,255);
draw_clear_alpha(neutral, 0); // alpha 0 pra manter cores?
// observe: usar alpha 0 pode deixar transparente. Se quiser, use alpha 1.

// desenha os mapas de distorção dinamicamente
// 1) desenha o sprite base (opcional)
// draw_sprite(spr_distort_map, 0, 0, 0);

// 2) desenha cada wave como um sprite escalado com blend
for (var i = 0; i < ds_list_size(dist_waves); i++) {
    var w = dist_waves[| i];
    var _x = w[0];
    var _y = w[1];
    var radius = w[3];
    var alpha = w[4];

    // desenha uma versão do spr_distort_map no ponto com escala relativa
    // assumindo spr_distort_map tem origem center e sprite de tamanho 256
    var sWidth = sprite_get_width(spr_distort_map);
    var sHeight = sprite_get_height(spr_distort_map);
    var scale = radius / (sWidth * 0.5); // ajusta pro tamanho do sprite
    draw_sprite_ext(spr_distort_map, 0, x, y, scale, scale, 0, c_white, alpha);
}

surface_reset_target();

// agora passamos a surface pro shader e desenhamos o application_surface com o shader
shader_set(shader_distort);

// passar uniform intensity (opcional)
shader_set_uniform_f(shader_get_uniform(shader_distort, "intensity"), global.distort_intensity);

// bind da texture
texture_set_stage(distortion_stage, surface_get_texture(surface_distort));

// desenha a tela já desenhada (application_surface)
draw_surface(application_surface, 0, 0);

shader_reset();

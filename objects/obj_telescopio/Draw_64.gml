if (ui_alpha < 0.01) exit;

draw_set_alpha(ui_alpha * 0.7);
draw_rectangle_color(0, 0, display_get_gui_width(), display_get_gui_height(), c_black, c_black, c_black, c_black, false);
draw_set_alpha(ui_alpha);

// Visor central escalado
var draw_x = visao_draw_x;
var draw_y = visao_draw_y;
draw_sprite_ext(spr_angulo_masmorra, 0, draw_x, draw_y, ui_scale, ui_scale, 0, c_white, ui_alpha);

// Borda estilosa verde Réia
var borda = 6 * ui_scale;
draw_set_color(c_lime);
draw_rectangle(draw_x - borda, draw_y - borda, draw_x + visao_draw_w + borda, draw_y + visao_draw_h + borda, true);
draw_set_color(c_white);
draw_rectangle(draw_x - borda/2, draw_y - borda/2, draw_x + visao_draw_w + borda/2, draw_y + visao_draw_h + borda/2, true);

// Desenha GMDs e notas por cima
if (global.jukebox_sintonizada) {
    
    for (var i = 0; i < array_length(inimigos); i++) {
        var gmd = inimigos[i];
        draw_sprite_ext(spr_gmd, gmd.image_index, gmd.x, gmd.y, ui_scale * 2, ui_scale * 2, 0, c_white, ui_alpha);
    }
    
    // Desenha notas animadas
    for (var i = 0; i < array_length(notas); i++) {
        var nota = notas[i];
        draw_sprite_ext(spr_notas, nota.image_index, nota.x, nota.y, ui_scale * 0.8, ui_scale * 0.8, 0, c_yellow, ui_alpha);
    }
}
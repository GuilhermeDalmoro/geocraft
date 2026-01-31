if (ui_anim <= 0.01) exit;

var gw = display_get_gui_width();
var gh = display_get_gui_height();

var cx = gw * 0.5;
var cy = gh * 0.5;

// escalas base
var scale_fundo   = ui_anim * 2.2;
var scale_espiral = ui_anim * 2.4;
var scale_nota    = ui_anim * 0.55;
var scale_dial    = ui_anim * 1.2;

// tempo
var t = current_time * 0.005;

draw_set_alpha(ui_anim);

// fundo
draw_sprite_ext( spr_sintonizar, 0, cx, cy, scale_fundo, scale_fundo, 0, c_white, 1 );

// posições
var espa = 180;
var pos_x = [cx - espa, cx, cx + espa];

// ===== ESPIRAIS =====
for (var i = 0; i < total_espirais; i++) {

    var px = pos_x[i];
    var py = cy;

    // espiral ativa pulsa
    var pulse = 1;
    if (i == espiral_atual && !completo) {
        pulse = 1 + sin(t * 4) * 0.04;
    }

    draw_sprite_ext( spr_espiral, 0, px, py, scale_espiral * pulse, scale_espiral * pulse, 0, c_white, 1 );

    // nota "respirando"
    var nota_pulse = 1 + sin(t * 3 + i) * 0.06;

    var nx = px + lengthdir_x(nota_dist[i] * scale_espiral, nota_ang[i]);
    var ny = py + lengthdir_y(nota_dist[i] * scale_espiral, nota_ang[i]);

    draw_sprite_ext( spr_notas, nota_frame[i], nx, ny, scale_nota * nota_pulse, scale_nota * nota_pulse, 0, quase_acerto && i == espiral_atual ? c_yellow : c_white, 1 );

    // ponteiro
    if (i == espiral_atual && !completo) {
        draw_sprite_ext( spr_dial, 0, px, py, scale_dial, scale_dial, ponteiro_ang, c_white, 1);
    }
}


// ===== DESENHO DO TOCA-DISCO =====
if (completo && toca_alpha > 0) {
    var scale_toca   = 2;
    var scale_disco  = 1.8;
    var scale_agulha = 1.8;


    draw_set_alpha(toca_alpha);

    // toca-disco
    draw_sprite_ext( spr_toca_disco, 0, toca_x, toca_y, scale_toca, scale_toca, 0, c_white, 1 );

    // disco
    if (toca_estado >= 2) {
        draw_sprite_ext( spr_disco, 0, disco_x, disco_y, scale_disco, scale_disco, disco_ang, c_white, disco_alpha);
    }

    // agulha (presa no canto superior esquerdo)
    var ag_x = toca_x - 42;
    var ag_y = toca_y - 30;

    draw_sprite_ext( spr_agulha, 0, ag_x, ag_y, scale_agulha, scale_agulha, agulha_ang, c_white, 1 );
}

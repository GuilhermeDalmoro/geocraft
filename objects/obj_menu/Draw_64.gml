draw_set_alpha(alpha_menu);
draw_set_font(fnt_geocraft);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

//================ MENU PRINCIPAL =================
if (estado == MENU_ESTADO.principal) {
    var ops = ["JOGAR", "MUNDOS", "OPÇÕES", "SAIR"];
    for (var i = 0; i < 4; i++) {
        draw_set_color(hover == i ? c_yellow : c_white);
        draw_text_transformed(room_width/2,  op_y_inicio + i*op_espaco,  ops[i], menu_scale[i] * escala_menu, menu_scale[i] * escala_menu, 0);
    }
}

//================ MUNDOS =========================
if (estado == MENU_ESTADO.mundos) {
    draw_text(room_width/2, op_y_inicio-80, "ESCOLHA O MUNDO");

    draw_sprite_ext(spr_mundo_facil,      0, room_width/2-220, room_height/2, hover==0?1.3:1, hover==0?1.3:1, 0, c_white, 1);
    draw_sprite_ext(spr_mundo_hardcore,   0, room_width/2,     room_height/2, hover==1?1.3:1, hover==1?1.3:1, 0, c_white, 1);
    draw_sprite_ext(spr_mundo_construcao, 0, room_width/2+220, room_height/2, hover==2?1.3:1, hover==2?1.3:1, 0, c_white, 1);
}

//================ OPÇÕES =========================
if (estado == MENU_ESTADO.opcoes) {
    draw_text(room_width/2, op_y_inicio-80, "OPÇÕES DO SDASH");

    // SLIDER
    draw_rectangle(slider_x_inicio, slider_y-10, slider_x_fim, slider_y+10, false);
    draw_rectangle(slider_x_inicio, slider_y-10,
                   slider_x_inicio + slider_comprimento*volume_visual,
                   slider_y+10, false);

    draw_circle(slider_x_inicio + slider_comprimento*volume_visual, slider_y, 14, false);

    draw_text(room_width/2, slider_y+40, string(round(volume_visual*100))+"%");

    // FULLSCREEN
    draw_text(room_width/2, op_y_inicio + op_espaco*2.2,
        "TELA CHEIA: " + (fullscreen ? "SIM" : "NÃO"));

    // DIFICULDADE
    var difs = ["FÁCIL", "NORMAL", "DIFÍCIL"];
    draw_text(room_width/2, op_y_inicio + op_espaco*3.8,
        "DIFICULDADE: " + difs[global.dificuldade]);

    // VOLTAR
    draw_text_transformed(room_width/2, op_y_inicio + op_espaco*6, "VOLTAR", hover==3?1.4:1, hover==3?1.4:1,  0);
}

//================ CURSOR SDASH ==================
//draw_sprite(spr_cursor_dejeto, 0, mouse_x, mouse_y);

//================ RESET DRAW ====================
draw_set_alpha(1);
draw_set_color(c_white);
draw_set_font(-1);
draw_set_halign(-1);
draw_set_valign(-1);


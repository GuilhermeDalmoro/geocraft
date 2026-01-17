//// Configs de desenho: Fonte pixel fofa (crie fnt_menu 24-32px bold!)
//draw_set_alpha(alpha_menu);
//draw_set_font(fnt_geocraft); // Ou fnt_menu se tiver
//draw_set_halign(fa_center);
//draw_set_valign(fa_middle);
//draw_set_color(c_white);
//
//// DEBUG: Texto gigante rosa se debug_mode=true (confirma que tá vivo!)
//if (debug_mode) {
    //draw_set_color(make_color_rgb(255, 182, 193)); // Rosa bebê Sdash!
    //draw_text_transformed(room_width/2, 50, "🐴 MENU CÚBICO VIVO! SDASH APROVA! 💕", 1.8 * escala_menu, 1.8 * escala_menu, 0);
    //draw_set_color(c_lime);
    //draw_text(room_width/2, 90, "R=Reset | Clique OPÇÕES > Arraste Volume!");
//}
//
//// Desenho por estado (vibrante como CúbicLand!)
//switch (estado) {
    //case menu_estado.principal:
        //// Título épico
        //draw_set_color(c_yellow);
        ////draw_text_transformed(room_width/2, op_y_inicio - 100, "GEOCRAFT", 2.5 * escala_menu, 2.5 * escala_menu, 0);
        //draw_set_color(c_white);
        ////draw_text(room_width/2, op_y_inicio - 60, "Aventura Cúbica de Sdash!");
//
        //// 4 opções com hover scale + cor
        //var ops = ["JOGAR (História)", "MUNDOS", "OPÇÕES", "SAIR"];
        //for (var i = 0; i < 4; i++) {
            //var op_x = room_width / 2;
            //var op_y = op_y_inicio + i * op_espaco;
            //var scale = (hover == i) ? 1.4 : 1;
            //var cor = (hover == i) ? c_yellow : c_white;
            //draw_set_color(cor);
            //draw_text_transformed(op_x, op_y, ops[i], scale * escala_menu, scale * escala_menu, 0);
        //}
        //break;
//
    //case menu_estado.mundos:
        //// Título
        //draw_text_transformed(room_width/2, op_y_inicio - 80, "ESCOLHA SEU MUNDO CÚBICO!", 1.6, 1.6, 0);
        //
        //// 3 sprites de mundos (crie-os: fácil=verde, hardcore=vermelho, constru=azul)
        //var tam_mundo = 80;
        //var mundo_x1 = room_width / 2 - 220;
        //var mundo_x2 = room_width / 2;
        //var mundo_x3 = room_width / 2 + 220;
        //var mundo_y = room_height / 2 - 20;
        //
        //// Desenho base
        //draw_sprite_ext(spr_mundo_facil, 0, mundo_x1, mundo_y, 1, 1, 0, c_white, 1);
        //draw_sprite_ext(spr_mundo_hardcore, 0, mundo_x2, mundo_y, 1, 1, 0, c_white, 1);
        //draw_sprite_ext(spr_mundo_construcao, 0, mundo_x3, mundo_y, 1, 1, 0, c_white, 1);
        //
        //// Hover: Scale + brilho!
        //var scale_hover = 1.3;
        //if (hover == 0) draw_sprite_ext(spr_mundo_facil, 0, mundo_x1, mundo_y, scale_hover, scale_hover, 0, c_yellow, 1);
        //if (hover == 1) draw_sprite_ext(spr_mundo_hardcore, 0, mundo_x2, mundo_y, scale_hover, scale_hover, 0, c_yellow, 1);
        //if (hover == 2) draw_sprite_ext(spr_mundo_construcao, 0, mundo_x3, mundo_y, scale_hover, scale_hover, 0, c_yellow, 1);
        //
        //// Labels
        //draw_set_color(c_white);
        //draw_text(mundo_x1, mundo_y + 60, "FÁCIL");
        //draw_text(mundo_x2, mundo_y + 60, "HARDCORE");
        //draw_text(mundo_x3, mundo_y + 60, "CONSTRUÇÃO");
        //break;
//
    //case menu_estado.opcoes:
        //// Título opções
        //draw_set_color(c_lime);
        //draw_text_transformed(room_width/2, op_y_inicio - 90, "OPÇÕES DO SDASH! �", 1.8, 1.8, 0);
        //
        //// VOLUME - Barra cúbica fofa!
        //draw_set_color(c_white);
        //draw_text(room_width/2, op_y_inicio - 10, "Volume Mestre:");
        //
        //// Fundo cinza
        //draw_set_color(c_dkgray);
        //draw_rectangle(slider_x_inicio, slider_y - 12, slider_x_fim, slider_y + 12, false);
        //
        //// Preenchimento ROSA SDASH (vibrante!)
        //draw_set_color(make_color_rgb(255, 182, 193));
        //draw_rectangle(slider_x_inicio, slider_y - 12, slider_x_inicio + (slider_comprimento * volume_visual), slider_y + 12, false);
        //
        //// Knob (círculo com brilho no hover!)
        //var knob_x = slider_x_inicio + (slider_comprimento * volume_visual);
        //var knob_cor = (hover == 10) ? c_yellow : c_white;
        //draw_set_color(knob_cor);
        //draw_circle(knob_x, slider_y, 18, false);
        //draw_set_color(c_black);
        //draw_circle(knob_x, slider_y, 14, false);
        //draw_set_color(c_white);
        //draw_text(knob_x, slider_y + 45, string(round(volume_visual * 100)) + "%");
        //
        //// Fullscreen
        //var fs_y = op_y_inicio + op_espaco * 2.2;
        //var fs_txt = "Tela Cheia: " + (fullscreen ? "SIM" : "NÃO");
        //draw_set_color(c_white);
        //draw_text(room_width/2, fs_y, fs_txt);
        //if (hover == 1) {
            //draw_set_color(c_yellow);
            //draw_text_transformed(room_width/2, fs_y, fs_txt, 1.2, 1.2, 0);
        //}
        //
        //// Dificuldade
        //var dif_y = op_y_inicio + op_espaco * 3.8;
        //var difs = ["FÁCIL", "NORMAL", "DIFÍCIL"];
        //var dif_txt = "Dificuldade: " + difs[global.dificuldade];
        //draw_set_color(c_white);
        //draw_text(room_width/2, dif_y, dif_txt);
        //if (hover == 2) {
            //draw_set_color(c_lime);
            //draw_text_transformed(room_width/2, dif_y, dif_txt, 1.2, 1.2, 0);
        //}
        //
        //// VOLTAR - Botão grande!
        //var voltar_y = op_y_inicio + op_espaco * 6;
        //draw_set_color(c_white);
        //draw_text(room_width/2, voltar_y, "VOLTAR");
        //if (hover == 3) {
            //draw_set_color(c_orange);
            //draw_text_transformed(room_width/2, voltar_y, "VOLTAR", 1.4, 1.4, 0);
        //}
        //break;
//}
//
//// Reset draw (sempre!)
//draw_set_alpha(1);
//draw_set_color(c_white);
//draw_set_font(-1);
//draw_set_halign(-1);
//draw_set_valign(-1);

draw_set_alpha(alpha_menu);
draw_set_font(fnt_geocraft);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

//================ MENU PRINCIPAL =================
if (estado == MENU_ESTADO.principal) {
    var ops = ["JOGAR", "MUNDOS", "OPÇÕES", "SAIR"];
    for (var i = 0; i < 4; i++) {
        draw_set_color(hover == i ? c_yellow : c_white);
        draw_text_transformed(
            room_width/2,
            op_y_inicio + i*op_espaco,
            ops[i],
            menu_scale[i] * escala_menu,
            menu_scale[i] * escala_menu,
            0
        );
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
    draw_text_transformed(room_width/2,
        op_y_inicio + op_espaco*6,
        "VOLTAR",
        hover==3?1.4:1,
        hover==3?1.4:1,
        0);
}

//================ CURSOR SDASH ==================
//draw_sprite(spr_cursor_dejeto, 0, mouse_x, mouse_y);

//================ RESET DRAW ====================
draw_set_alpha(1);
draw_set_color(c_white);
draw_set_font(-1);
draw_set_halign(-1);
draw_set_valign(-1);

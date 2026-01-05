if (global.pause && !global.dialogo_acontecendo && !global.pause_por_inventario) {
    var _largura_tela = display_get_gui_width();
    var _altura_tela = display_get_gui_height();

    // Fundo gradiente minimalista
    draw_set_alpha(bg_alpha);
    draw_rectangle_color(0, 0, _largura_tela, _altura_tela, #1A2029, #1A2029,#1A2304, #660066, false);
    draw_set_alpha(1);

    // Título
    draw_set_font(fnt_dialogo);
    draw_set_color(c_black);
    draw_text(_largura_tela / 2 - 60, _altura_tela / 2 - 120, "PAUSADO"); // Sombra
    draw_set_color(#00CC99); // Verde neon suave
    draw_text(_largura_tela / 2 - 62, _altura_tela / 2 - 122, "PAUSADO");

    // Opções
    var _x = _largura_tela / 2 - 100;
    var _y_start = _altura_tela / 2 - 40;
    for (var i = 0; i < array_length(global.pause_menu.options); i++) {
        var _y = _y_start + i * 40;
        draw_set_color(c_black);
        draw_text(_x + 2, _y + 2, global.pause_menu.options[i]); // Sombra
        draw_set_color(#FFFFFF); // Branco puro
        if (i == global.pause_menu.selected) {
            draw_text(_x, _y, global.pause_menu.options[i]); // Texto normal
            draw_set_color(#00CC99); // Sublinhado neon
            draw_line(_x, _y + 20, _x + string_width(global.pause_menu.options[i]), _y + 20); // Sublinhado animado
        } else {
            draw_text(_x, _y, global.pause_menu.options[i]); // Texto normal
        }
    }
}
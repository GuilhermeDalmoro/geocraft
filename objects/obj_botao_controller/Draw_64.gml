if (global.batalha_menu == 0 && global.comeca_batalha) {
    for (var i = 0; i < array_length(opcoes); i++) {
        draw_set_font(fnt_ui_batalha);
        draw_set_color(i == opcao_selecionada ? c_yellow : c_white);
        var _scale = (i == opcao_selecionada) ? 1 + sin(current_time * 0.005) * 0.1 : 1;
        draw_text_transformed(50, 400 + i * 50, opcoes[i], _scale, _scale, 0);
    }
}
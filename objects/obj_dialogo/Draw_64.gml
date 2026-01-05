// Draw GUI Event
if (inicializar) {
    var _guil = display_get_gui_width();
    var _guia = display_get_gui_height();
    var _xx = 0;
    var _yy = _guia - 200;
    var _c = c_black;
    var _sprite_ret = texto_grid[# Infosnpc.Retrato, pagina];
    var _texto = string_copy(texto_grid[# Infosnpc.Texto, pagina], 1, caractere);
    draw_set_font(fnt_dialogo);

    if (texto_grid[# Infosnpc.Lado, pagina] == 0) {
        draw_rectangle_color(_xx + 200, _yy, _guil, _guia, _c, _c, _c, _c, false);
        draw_rectangle_color(_xx + 200, _yy + 1, _guil, _guia, c_white, c_white, c_white, c_white, true);
        draw_rectangle_color(_xx + 201, _yy + 2, _guil, _guia, c_white, c_white, c_white, c_white, true);
        draw_rectangle_color(_xx + 202, _yy + 3, _guil, _guia, c_white, c_white, c_white, c_white, true);
        draw_text_effect(_xx + 264, _yy + 32, _texto, 32, _guil - 264, palavras, efeitos);
        draw_set_font(fnt_nome_npc_dialogo);
        draw_set_color(c_white);
        draw_text(_xx + 216, _yy - 32, texto_grid[# Infosnpc.Nome, pagina]);
        draw_set_font(-1);
        draw_set_color(c_white);
        draw_sprite_ext(_sprite_ret, 0, 100, _guia, 3, 3, 0, c_white, 1);
    } else {
        draw_rectangle_color(_xx, _yy, _guil - 200, _guia, _c, _c, _c, _c, false);
        draw_rectangle_color(_xx, _yy + 1, _guil - 200, _guia, c_white, c_white, c_white, c_white, true);
        draw_rectangle_color(_xx, _yy + 2, _guil - 201, _guia, c_white, c_white, c_white, c_white, true);
        draw_rectangle_color(_xx, _yy + 3, _guil - 202, _guia, c_white, c_white, c_white, c_white, true);
        draw_text_effect(_xx + 64, _yy + 32, _texto, 32, _guil - 264, palavras, efeitos);
        var _strw = string_width(texto_grid[# Infosnpc.Nome, pagina]);
        draw_set_font(fnt_nome_npc_dialogo);
        draw_set_color(c_white);
        draw_text(_guil - 216 - _strw, _yy - 32, texto_grid[# Infosnpc.Nome, pagina]);
        draw_set_font(-1);
        draw_set_color(c_white);
        draw_sprite_ext(_sprite_ret, 0, _guil - 100, _guia, -3, 3, 0, c_white, 1);
    }

    draw_set_font(fnt_dialogo);
    if (opcao_draw) {
        var _opx = _xx + 32;
        var _opy = _yy - 32;
        var _opsep = 48;
        var _opborda = 6;
        opcao_selecionado += keyboard_check_pressed(ord("W")) - keyboard_check_pressed(ord("S"));
        opcao_selecionado = clamp(opcao_selecionado, 0, opcao_numero - 1);

        for (var i = 0; i < opcao_numero; i++) {
            var _stringw = string_width(opcao[i]);
            draw_sprite_ext(spr_bg_opcoes, 0, _opx, _opy - (_opsep * i), (_stringw + _opborda * 2) / 16, 1, 0, c_white, 1);
            draw_text(_opx + _opborda, _opy - (_opsep * i), opcao[i]);
		
            if (opcao_selecionado == i) {
                draw_sprite(spr_seletor_opcoes, 0, _xx + 8, _opy - (_opsep * i) + 8);
            }
        }

        if (keyboard_check_pressed(vk_enter) || gamepad_button_check_pressed(global.controle, gp_face1)) {
            var _dialogo = instance_create_layer(x, y, "Dialogo", obj_dialogo);
            _dialogo.npc_nome = opcao_resposta[opcao_selecionado];
            instance_destroy();
        }
    }
    draw_set_font(-1);
}
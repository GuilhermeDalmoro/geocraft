var _gw = display_get_gui_width();
var _gh = display_get_gui_height();

draw_set_alpha(bg_alpha);

// Escurece o background animado da room sem esconder a identidade.
draw_set_color(make_color_rgb(8, 8, 18));
draw_set_alpha(0.70 * bg_alpha);
draw_rectangle(0, 0, _gw, _gh, false);
draw_set_alpha(bg_alpha);

// Titulo.
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_font(fnt_geocraft);

draw_set_color(c_black);
draw_text_transformed(_gw * 0.73 + 4, _gh * 0.22 + title_float + 5, "GEOCRAFT", 1.55, 1.55, 0);

draw_set_color(make_color_rgb(255, 125, 190));
draw_text_transformed(_gw * 0.73, _gh * 0.22 + title_float, "GEOCRAFT", 1.55, 1.55, 0);

draw_set_font(fnt_dialogo_small);
draw_set_color(c_white);
draw_text(_gw * 0.73, _gh * 0.30 + title_float, "CubicLand precisa de um cowboy.");

draw_set_color(c_gray);
draw_text(_gw * 0.73, _gh * 0.34 + title_float, "Gameplay Core v4");

// Painel de conteudo.
draw_set_halign(fa_left);
draw_set_valign(fa_top);

if (estado == MENU_ESTADO.principal) {
    var _bx = _gw * 0.25;
    var _by = _gh * 0.34;
    var _bw = min(390, _gw * 0.34);
    var _bh = 46;
    var _gap = 54;

    var _continue_slot = get_continue_slot();

    for (var _i = 0; _i < array_length(main_options); _i++) {
        var _yy = _by + _i * _gap;
        var _selected = (_i == selected_main);
        var _enabled = !(_i == 0 && _continue_slot == -1);

        draw_set_alpha(_selected ? 0.34 : 0.18);
        draw_set_color(_selected ? make_color_rgb(255, 125, 190) : c_black);
        draw_rectangle(_bx - _bw * 0.5, _yy - _bh * 0.5, _bx + _bw * 0.5, _yy + _bh * 0.5, false);

        draw_set_alpha(1);
        draw_set_color(!_enabled ? c_gray : (_selected ? c_yellow : c_white));

        var _prefix = _selected ? "> " : "  ";
        draw_text(_bx - _bw * 0.5 + 20, _yy - 9, _prefix + main_options[_i]);
    }

    if (_continue_slot == -1) {
        draw_set_color(c_gray);
        draw_text(_gw * 0.53, _gh * 0.47, "Nenhum save ainda.");
        draw_text(_gw * 0.53, _gh * 0.50, "Escolha NOVO JOGO para iniciar sua historia.");
    }
    else {
        var _meta = save_meta[_continue_slot - 1];

        draw_set_color(c_yellow);
        draw_text(_gw * 0.53, _gh * 0.44, "CONTINUAR - SLOT " + string(_continue_slot));

        draw_set_color(c_white);
        draw_text(_gw * 0.53, _gh * 0.48, "Local: " + _meta.room_name);
        draw_text(_gw * 0.53, _gh * 0.51, "Etapa: " + (_meta.stage == "" ? "desconhecida" : _meta.stage));
        draw_text(_gw * 0.53, _gh * 0.54, "Moedas: " + string(_meta.moedas));
        draw_text(_gw * 0.53, _gh * 0.57, "Vida: " + string(_meta.vida) + "/" + string(_meta.max_vida));
    }

    draw_set_color(c_gray);
    draw_text(24, _gh - 34, "W/S + ENTER ou mouse");
}

if (estado == MENU_ESTADO.novo_slot || estado == MENU_ESTADO.carregar_slot) {
    draw_set_halign(fa_center);
    draw_set_color(c_yellow);
    draw_text(_gw * 0.5, 58, estado == MENU_ESTADO.novo_slot ? "NOVO JOGO" : "CARREGAR JOGO");

    draw_set_color(c_white);
    draw_text(_gw * 0.5, 84, "Escolha um dos 3 slots");

    var _sx = _gw * 0.5;
    var _sy = _gh * 0.31;
    var _sw = min(760, _gw - 120);
    var _sh = 105;
    var _sgap = 118;

    for (var _i = 0; _i < 3; _i++) {
        var _meta = save_meta[_i];
        var _slot_y = _sy + _i * _sgap;
        var _selected = (_i == selected_slot);

        draw_set_alpha(_selected ? 0.38 : 0.20);
        draw_set_color(_selected ? make_color_rgb(255, 125, 190) : c_black);
        draw_rectangle(_sx - _sw * 0.5, _slot_y - _sh * 0.5, _sx + _sw * 0.5, _slot_y + _sh * 0.5, false);
        draw_set_alpha(1);

        draw_set_halign(fa_left);
        draw_set_color(_selected ? c_yellow : c_white);
        draw_text(_sx - _sw * 0.5 + 24, _slot_y - 36, "SLOT " + string(_i + 1));

        if (_meta.exists) {
            draw_set_color(c_white);
            draw_text(_sx - _sw * 0.5 + 24, _slot_y - 9, _meta.room_name);
            draw_text(_sx - _sw * 0.5 + 280, _slot_y - 9, "Moedas: " + string(_meta.moedas));
            draw_text(_sx - _sw * 0.5 + 500, _slot_y - 9, "HP: " + string(_meta.vida) + "/" + string(_meta.max_vida));

            draw_set_color(c_gray);
            draw_text(_sx - _sw * 0.5 + 24, _slot_y + 19, "Etapa: " + (_meta.stage == "" ? "save legado" : _meta.stage));
        }
        else {
            draw_set_color(c_gray);
            draw_text(_sx - _sw * 0.5 + 24, _slot_y, "VAZIO");
        }

        draw_set_halign(fa_center);
    }

    if (estado == MENU_ESTADO.novo_slot && confirm_overwrite) {
        draw_set_color(c_red);
        draw_text(_gw * 0.5, _gh - 74, "Esse slot ja tem save. ENTER novamente para APAGAR e comecar.");
    }
    else if (estado == MENU_ESTADO.carregar_slot && !save_meta[selected_slot].exists) {
        draw_set_color(c_gray);
        draw_text(_gw * 0.5, _gh - 74, "Esse slot esta vazio.");
    }

    draw_set_color(c_white);
    draw_text(_gw * 0.5, _gh - 42, "ESC para voltar");
    draw_set_halign(fa_left);
}

if (estado == MENU_ESTADO.mundos) {
    draw_set_halign(fa_center);
    draw_set_color(c_yellow);
    draw_text(_gw * 0.5, 70, "MUNDOS EXTRAS");

    draw_set_color(c_gray);
    draw_text(_gw * 0.5, 96, "Modos paralelos ao save principal");

    var _wx = _gw * 0.5;
    var _wy = _gh * 0.52;
    var _spacing = 230;

    var _sprites = [spr_mundo_facil, spr_mundo_hardcore, spr_mundo_construcao];

    for (var _i = 0; _i < 3; _i++) {
        var _cx = _wx + (_i - 1) * _spacing;
        var _selected = (_i == selected_world);

        draw_set_alpha(_selected ? 0.35 : 0.18);
        draw_set_color(_selected ? make_color_rgb(255, 125, 190) : c_black);
        draw_rectangle(_cx - 96, _wy - 96, _cx + 96, _wy + 96, false);
        draw_set_alpha(1);

        draw_sprite_ext(_sprites[_i], 0, _cx, _wy - 10, _selected ? 1.2 : 1, _selected ? 1.2 : 1, 0, c_white, 1);

        draw_set_color(_selected ? c_yellow : c_white);
        draw_text(_cx, _wy + 70, world_options[_i]);
    }

    draw_set_color(c_white);
    draw_text(_gw * 0.5, _gh - 42, "A/D ou setas + ENTER | ESC volta");
    draw_set_halign(fa_left);
}

if (estado == MENU_ESTADO.opcoes) {
    draw_set_halign(fa_center);
    draw_set_color(c_yellow);
    draw_text(_gw * 0.5, 70, "OPCOES");

    var _difs = ["FACIL", "NORMAL", "DIFICIL"];
    var _rows = [
        "VOLUME: " + string(round(volume_visual * 100)) + "%",
        "TELA CHEIA: " + (fullscreen ? "SIM" : "NAO"),
        "DIFICULDADE: " + _difs[global.dificuldade],
        "VOLTAR"
    ];

    var _ox = _gw * 0.5;
    var _oy = _gh * 0.34;

    for (var _i = 0; _i < 4; _i++) {
        var _yy = _oy + _i * 78;
        var _selected = (_i == selected_option);

        draw_set_alpha(_selected ? 0.36 : 0.18);
        draw_set_color(_selected ? make_color_rgb(255, 125, 190) : c_black);
        draw_rectangle(_ox - 280, _yy - 29, _ox + 280, _yy + 29, false);
        draw_set_alpha(1);

        draw_set_color(_selected ? c_yellow : c_white);
        draw_text(_ox, _yy - 8, _rows[_i]);
    }

    draw_set_color(c_gray);
    draw_text(_gw * 0.5, _gh - 64, "A/D altera valores | ENTER confirma | ESC salva e volta");
    draw_set_halign(fa_left);
}

draw_set_alpha(1);
draw_set_color(c_white);
draw_set_font(-1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

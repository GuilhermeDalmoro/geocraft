var _gw = display_get_gui_width();
var _gh = display_get_gui_height();

draw_set_alpha(0.94);
draw_set_color(make_color_rgb(6, 8, 14));
draw_rectangle(0, 0, _gw, _gh, false);
draw_set_alpha(1);

draw_set_font(fnt_geocraft);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

draw_set_color(c_fuchsia);
draw_text(18, 14, "GEOCRAFT DEV CONSOLE");

draw_set_font(fnt_dialogo_small);
draw_set_halign(fa_right);
draw_set_color(c_gray);
draw_text(_gw - 18, 20, "[F9] fechar  |  [TAB] trocar aba");
draw_set_halign(fa_left);

// Abas.
var _tab_x = 18;
var _tab_y = 56;
var _tab_gap = 4;
var _tab_w = max(92, floor((_gw - 36 - _tab_gap * (array_length(tab_names) - 1)) / array_length(tab_names)));
var _tab_h = 34;

for (var _ti = 0; _ti < array_length(tab_names); _ti++) {
    var _x1 = _tab_x + _ti * (_tab_w + _tab_gap);
    var _selected = (_ti == tab);

    draw_set_color(
        _selected
            ? make_color_rgb(115, 42, 100)
            : make_color_rgb(28, 30, 42)
    );

    draw_rectangle(
        _x1,
        _tab_y,
        _x1 + _tab_w,
        _tab_y + _tab_h,
        false
    );

    draw_set_halign(fa_center);
    draw_set_color(_selected ? c_yellow : c_white);
    draw_text(_x1 + _tab_w * 0.5, _tab_y + 9, tab_names[_ti]);
}

draw_set_halign(fa_left);

var _cx = 28;
var _cy = 112;
var _cw = _gw - 56;
var _ch = _gh - 154;

draw_set_color(make_color_rgb(18, 20, 30));
draw_rectangle(_cx, _cy, _cx + _cw, _cy + _ch, false);

draw_set_color(make_color_rgb(65, 68, 88));
draw_rectangle(_cx + 2, _cy + 2, _cx + _cw - 2, _cy + _ch - 2, true);

var _x = _cx + 20;
var _y = _cy + 18;

function dev_draw_row(_label, _value, _index, _selected_row, _base_x, _base_y, _panel_x, _panel_w) {
    var _yy = _base_y + _index * 30;

    if (_index == _selected_row) {
        draw_set_alpha(0.22);
        draw_set_color(c_fuchsia);
        draw_rectangle(_base_x - 8, _yy - 5, _panel_x + _panel_w - 18, _yy + 23, false);
        draw_set_alpha(1);
    }

    draw_set_color(_index == _selected_row ? c_yellow : c_white);
    draw_text(_base_x, _yy, _label);

    draw_set_halign(fa_right);
    draw_set_color(c_aqua);
    draw_text(_panel_x + _panel_w - 30, _yy, string(_value));
    draw_set_halign(fa_left);
}

// RESUMO
if (tab == 0) {
    var _labels = [
        "+100 moedas",
        "Restaurar vida + estamina",
        "Adicionar materiais de teste",
        "Concluir missao rastreada",
        "Alternar overlay F10",
        "Salvar slot atual"
    ];

    draw_set_color(c_gray);
    draw_text(_x, _y - 2, "Acoes rapidas");

    _y += 32;

    for (var _i = 0; _i < array_length(_labels); _i++) {
        dev_draw_row(_labels[_i], "[ENTER]", _i, row, _x, _y, _cx, _cw);
    }

    draw_set_color(c_gray);
    draw_text(_x, _cy + _ch - 34, "ENTER executa a acao selecionada.");
}

// PLAYER
if (tab == 1) {
    if (!instance_exists(obj_sdash)) {
        draw_set_color(c_red);
        draw_text(_x, _y, "Sdash nao existe nesta room.");
    }
    else {
        var _p = instance_find(obj_sdash, 0);

        var _speed_text = variable_instance_exists(_p, "vel_normal")
            ? string(_p.vel_normal)
            : "N/A";

        var _values = [
            string(_p.vida),
            string(_p.max_vida),
            string(_p.estamina),
            string(_p.max_estamina),
            string(_p.dano),
            string(round(_p.x)),
            string(round(_p.y)),
            _speed_text,
            string(_p.active)
        ];

        var _labels = [
            "Vida",
            "Vida maxima",
            "Estamina",
            "Estamina maxima",
            "Dano",
            "X",
            "Y",
            "Velocidade",
            "Active"
        ];

        for (var _i = 0; _i < array_length(_labels); _i++) {
            dev_draw_row(_labels[_i], _values[_i], _i, row, _x, _y, _cx, _cw);
        }

        draw_set_color(c_gray);
        draw_text(_x, _cy + _ch - 34, "A/D altera | ENTER restaura/toggle quando aplicavel.");
    }
}

// CAMPANHA
if (tab == 2) {
    var _labels = [
        "Capitulo",
        "Moedas",
        "Inimigos mortos",
        "Cavalos alimentados",
        "Orbs",
        "Tutorial",
        "Area 1",
        "Area 2",
        "Area 3",
        "Area 4",
        "Area 5",
        "Area 6",
        "Etapa da campanha"
    ];

    var _values = [
        global.game_state.campaign.chapter,
        global.moedas,
        global.inimigos_mortos,
        global.cabalos_alimentados,
        global.orbs,
        global.tutorial,
        global.game_state.campaign.areas[0],
        global.game_state.campaign.areas[1],
        global.game_state.campaign.areas[2],
        global.game_state.campaign.areas[3],
        global.game_state.campaign.areas[4],
        global.game_state.campaign.areas[5],
        global.game_state.campaign.stage
    ];

    for (var _i = 0; _i < array_length(_labels); _i++) {
        dev_draw_row(_labels[_i], _values[_i], _i, row, _x, _y, _cx, _cw);
    }

    draw_set_color(c_gray);
    draw_text(_x, _cy + _ch - 34, "A/D altera valores e toggles.");
}

// MISSOES
if (tab == 3) {
    if (!is_array(global.missoes) || array_length(global.missoes) <= 0) {
        draw_set_color(c_red);
        draw_text(_x, _y, "Nenhuma missao carregada.");
    }
    else {
        quest_index = clamp(quest_index, 0, array_length(global.missoes) - 1);

        var _q = global.missoes[quest_index];

        draw_set_color(c_yellow);
        draw_text(_x, _y, "[" + string(quest_index + 1) + "/" + string(array_length(global.missoes)) + "] " + _q.nome);

        draw_set_color(c_aqua);
        draw_text(_x, _y + 28, "ID: " + _q.id_m + "   STATUS: " + _q.status);

        draw_set_color(c_white);
        draw_text_ext(_x, _y + 54, _q.descricao, 18, _cw - 60);

        var _oy = _y + 108;

        if (is_array(_q.objetivos) && array_length(_q.objetivos) > 0) {
            for (var _oi = 0; _oi < array_length(_q.objetivos); _oi++) {
                var _o = _q.objetivos[_oi];

                draw_set_color(
                    _oi == quest_objective_index
                        ? c_yellow
                        : (_o.complete ? c_lime : c_white)
                );

                draw_text(
                    _x + 20,
                    _oy + _oi * 26,
                    (_oi == quest_objective_index ? "> " : "  ")
                    + _o.label
                    + "  "
                    + string(_o.current)
                    + "/"
                    + string(_o.required)
                );
            }
        }
        else {
            draw_set_color(c_gray);
            draw_text(_x + 20, _oy, "Sem objetivos.");
        }

        draw_set_color(c_gray);
        draw_text(
            _x,
            _cy + _ch - 56,
            "W/S missao | A/D objetivo | Q/E -/+ progresso"
        );
        draw_text(
            _x,
            _cy + _ch - 32,
            "A ativar | C concluir | R resetar | ENTER rastrear"
        );
    }
}

// INVENTARIO
if (tab == 4) {
    if (!variable_global_exists("itens") || !ds_exists(global.itens, ds_type_list)) {
        draw_set_color(c_red);
        draw_text(_x, _y, "Banco de itens nao inicializado.");
    }
    else {
        var _count = ds_list_size(global.itens);
        item_index = clamp(item_index, 0, max(0, _count - 1));

        var _first = max(0, item_index - 6);
        var _last = min(_count - 1, _first + 13);

        if (_last - _first < 13) {
            _first = max(0, _last - 13);
        }

        for (var _ii = _first; _ii <= _last; _ii++) {
            var _item = global.itens[| _ii];
            var _yy = _y + (_ii - _first) * 28;
            var _selected = (_ii == item_index);
            var _have = procura_item_inventario(_ii);

            draw_set_color(_selected ? c_yellow : c_white);
            draw_text(
                _x,
                _yy,
                (_selected ? "> " : "  ")
                + "#"
                + string(_ii)
                + " "
                + _item.nome
            );

            draw_set_halign(fa_right);
            draw_set_color(c_aqua);
            draw_text(_cx + _cw - 30, _yy, "x" + string(_have));
            draw_set_halign(fa_left);
        }

        draw_set_color(c_gray);
        draw_text(_x, _cy + _ch - 56, "ENTER/E adiciona 1 | SHIFT = 10");
        draw_text(_x, _cy + _ch - 32, "Q remove | C limpa inventario");
    }
}

// ESTADO
if (tab == 5) {
    var _mode_name = state_mode == 0
        ? "FLAGS"
        : (state_mode == 1 ? "REPUTACAO" : "AREAS");

    draw_set_color(c_yellow);
    draw_text(_x, _y, "<Q  " + _mode_name + "  E>");

    var _list_y = _y + 40;

    if (state_mode == 0) {
        var _flags = variable_struct_get_names(global.game_state.campaign.flags);

        if (array_length(_flags) <= 0) {
            draw_set_color(c_gray);
            draw_text(_x, _list_y, "Nenhuma flag criada ainda. Use o console: flag nome true");
        }
        else {
            state_index = clamp(state_index, 0, array_length(_flags) - 1);

            for (var _i = 0; _i < array_length(_flags); _i++) {
                var _name = _flags[_i];
                var _yy = _list_y + _i * 26;

                if (_yy > _cy + _ch - 60) break;

                draw_set_color(_i == state_index ? c_yellow : c_white);
                draw_text(_x, _yy, (_i == state_index ? "> " : "  ") + _name);

                draw_set_halign(fa_right);
                draw_set_color(c_aqua);
                draw_text(
                    _cx + _cw - 30,
                    _yy,
                    string(variable_struct_get(global.game_state.campaign.flags, _name))
                );
                draw_set_halign(fa_left);
            }
        }

        draw_set_color(c_gray);
        draw_text(_x, _cy + _ch - 32, "ENTER alterna a flag selecionada.");
    }
    else if (state_mode == 1) {
        for (var _i = 0; _i < array_length(rep_names); _i++) {
            var _name = rep_names[_i];
            var _yy = _list_y + _i * 26;

            if (_yy > _cy + _ch - 60) break;

            var _value = variable_struct_exists(global.game_state.campaign.reputation, _name)
                ? variable_struct_get(global.game_state.campaign.reputation, _name)
                : 0;

            draw_set_color(_i == state_index ? c_yellow : c_white);
            draw_text(_x, _yy, (_i == state_index ? "> " : "  ") + _name);

            draw_set_halign(fa_right);
            draw_set_color(c_aqua);
            draw_text(_cx + _cw - 30, _yy, string(_value));
            draw_set_halign(fa_left);
        }

        draw_set_color(c_gray);
        draw_text(_x, _cy + _ch - 32, "A/D altera reputacao.");
    }
    else {
        for (var _i = 0; _i < 6; _i++) {
            dev_draw_row(
                "Area " + string(_i + 1),
                global.game_state.campaign.areas[_i],
                _i,
                state_index
            , _x, _y, _cx, _cw);
        }

        draw_set_color(c_gray);
        draw_text(_x, _cy + _ch - 32, "ENTER/A/D alterna area.");
    }
}

// MUNDO
if (tab == 6) {
    var _mode_name = world_mode == 0 ? "TELEPORT" : "SPAWN";

    draw_set_color(c_yellow);
    draw_text(_x, _y, "<Q  " + _mode_name + "  E>");

    var _list = world_mode == 0 ? room_names : spawn_names;
    var _list_y = _y + 40;

    for (var _i = 0; _i < array_length(_list); _i++) {
        var _yy = _list_y + _i * 24;

        if (_yy > _cy + _ch - 60) break;

        draw_set_color(_i == world_index ? c_yellow : c_white);
        draw_text(
            _x,
            _yy,
            (_i == world_index ? "> " : "  ") + _list[_i]
        );
    }

    draw_set_color(c_gray);

    if (world_mode == 0) {
        draw_text(_x, _cy + _ch - 32, "ENTER teleporta para a room.");
    }
    else {
        draw_text(_x, _cy + _ch - 32, "ENTER spawna | DELETE destroi todas desse tipo.");
    }
}

// SAVES
if (tab == 7) {
    draw_set_color(c_yellow);
    draw_text(_x, _y, "SLOT " + string(save_slot_dev) + "   [A/D muda slot]");

    var _actions = [
        "Salvar agora",
        "Carregar slot",
        "Apagar slot",
        "Novo jogo nesse slot"
    ];

    _y += 48;

    for (var _i = 0; _i < array_length(_actions); _i++) {
        dev_draw_row(_actions[_i], "[ENTER]", _i, save_action, _x, _y, _cx, _cw);
    }

    if (variable_global_exists("save_slot_meta")) {
        var _meta = global.save_slot_meta(save_slot_dev);

        draw_set_color(c_aqua);
        draw_text(_x + 440, _y, _meta.exists ? "SAVE EXISTE" : "SLOT VAZIO");

        if (_meta.exists) {
            draw_set_color(c_white);
            draw_text(_x + 440, _y + 30, "Room: " + _meta.room_name);
            draw_text(_x + 440, _y + 54, "Etapa: " + _meta.stage);
            draw_text(_x + 440, _y + 78, "Moedas: " + string(_meta.moedas));
            draw_text(_x + 440, _y + 102, "HP: " + string(_meta.vida) + "/" + string(_meta.max_vida));
        }
    }
}

// CONSOLE
if (tab == 8) {
    draw_set_color(c_yellow);
    draw_text(_x, _y, "CONSOLE DE COMANDOS");

    draw_set_color(c_gray);
    draw_text(_x, _y + 28, "ENTER comeca a digitar. Digite 'help' para a lista.");

    var _log_y = _y + 72;

    for (var _i = 0; _i < array_length(console_log); _i++) {
        draw_set_color(_i == array_length(console_log) - 1 ? c_aqua : c_white);
        draw_text_ext(_x, _log_y + _i * 24, console_log[_i], 18, _cw - 60);
    }

    var _input_y = _cy + _ch - 58;

    draw_set_color(make_color_rgb(28, 30, 42));
    draw_rectangle(_x, _input_y, _cx + _cw - 24, _input_y + 36, false);

    draw_set_color(console_typing ? c_yellow : c_gray);
    draw_text(
        _x + 10,
        _input_y + 9,
        console_typing
            ? "> " + console_buffer + "_"
            : "[ENTER] digitar comando"
    );
}

draw_set_alpha(1);
draw_set_color(c_white);
draw_set_font(-1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

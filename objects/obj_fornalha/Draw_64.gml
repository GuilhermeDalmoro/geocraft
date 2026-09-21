if (!ui_open) exit;

if (!instance_exists(obj_sdash)) exit;

var _gw = display_get_gui_width();
var _gh = display_get_gui_height();

var _panel_w = min(880, _gw - 50);
var _panel_h = min(590, _gh - 50);

var _px = (_gw - _panel_w) * 0.5;
var _py = (_gh - _panel_h) * 0.5;

var _mouse_x = device_mouse_x_to_gui(0);
var _mouse_y = device_mouse_y_to_gui(0);

var _recipes = receitas_fornalha;
ui_selected = clamp(ui_selected, 0, array_length(_recipes) - 1);
var _recipe = _recipes[ui_selected];

// Fundo escurecido.
draw_set_alpha(0.60);
draw_set_color(c_black);
draw_rectangle(0, 0, _gw, _gh, false);

// Painel principal.
draw_set_alpha(0.98);
draw_set_color(make_color_rgb(23, 19, 25));
draw_rectangle(
    _px,
    _py,
    _px + _panel_w,
    _py + _panel_h,
    false
);

draw_set_alpha(1);

// Moldura dupla pixel-art.
draw_set_color(make_color_rgb(255, 137, 48));
draw_rectangle(
    _px + 3,
    _py + 3,
    _px + _panel_w - 3,
    _py + _panel_h - 3,
    true
);

draw_set_color(make_color_rgb(116, 63, 40));
draw_rectangle(
    _px + 7,
    _py + 7,
    _px + _panel_w - 7,
    _py + _panel_h - 7,
    true
);


// =====================================================
// CABECALHO
// =====================================================

draw_set_font(fnt_geocraft);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

draw_set_color(c_black);
draw_text(_px + 28 + 2, _py + 22 + 2, "FORNALHA CUBICA");

draw_set_color(make_color_rgb(255, 174, 68));
draw_text(_px + 28, _py + 22, "FORNALHA CUBICA");

draw_set_font(fnt_dialogo_small);

draw_set_color(c_gray);
draw_text(
    _px + 30,
    _py + 66,
    "Transforme sucata cubica em algo quase util."
);

// Botao X.
var _close_x1 = _px + _panel_w - 52;
var _close_y1 = _py + 14;
var _close_x2 = _px + _panel_w - 18;
var _close_y2 = _py + 46;

var _close_hover = point_in_rectangle(
    _mouse_x,
    _mouse_y,
    _close_x1,
    _close_y1,
    _close_x2,
    _close_y2
);

draw_set_color(
    _close_hover
        ? make_color_rgb(255, 95, 95)
        : make_color_rgb(90, 54, 58)
);
draw_rectangle(
    _close_x1,
    _close_y1,
    _close_x2,
    _close_y2,
    false
);

draw_set_halign(fa_center);
draw_set_color(c_white);
draw_text(
    (_close_x1 + _close_x2) * 0.5,
    _close_y1 + 7,
    "X"
);
draw_set_halign(fa_left);


// =====================================================
// LISTA DE RECEITAS
// =====================================================

var _list_x1 = _px + 26;
var _list_x2 = _px + 350;
var _list_y = _py + 116;
var _card_h = 68;
var _card_gap = 78;

draw_set_color(c_yellow);
draw_text(_list_x1, _py + 94, "RECEITAS");

for (var _i = 0; _i < array_length(_recipes); _i++) {
    var _r = _recipes[_i];
    var _card_y = _list_y + _i * _card_gap;

    var _hover = point_in_rectangle(
        _mouse_x,
        _mouse_y,
        _list_x1,
        _card_y,
        _list_x2,
        _card_y + _card_h
    );

    var _selected = (_i == ui_selected);

    draw_set_alpha(_selected ? 0.92 : (_hover ? 0.72 : 0.48));

    draw_set_color(
        _selected
            ? make_color_rgb(86, 55, 50)
            : make_color_rgb(42, 39, 50)
    );

    draw_rectangle(
        _list_x1,
        _card_y,
        _list_x2,
        _card_y + _card_h,
        false
    );

    draw_set_alpha(1);

    if (_selected) {
        draw_set_color(make_color_rgb(255, 137, 48));
        draw_rectangle(
            _list_x1 + 2,
            _card_y + 2,
            _list_x2 - 2,
            _card_y + _card_h - 2,
            true
        );
    }

    var _out = global.itens[| _r.resultado];

    draw_sprite_ext(
        _out.spr,
        _out.frames,
        _list_x1 + 34,
        _card_y + 34,
        0.70,
        0.70,
        0,
        c_white,
        1
    );

    draw_set_color(_selected ? c_yellow : c_white);
    draw_text(_list_x1 + 68, _card_y + 13, _r.nome);

    draw_set_color(c_gray);
    draw_text(
        _list_x1 + 68,
        _card_y + 38,
        string(round(_r.duracao / room_speed)) + "s  |  madeira x" + string(_r.combustivel)
    );
}


// =====================================================
// DETALHES DA RECEITA
// =====================================================

var _detail_x = _px + 385;
var _detail_w = _panel_w - 420;

draw_set_color(c_yellow);
draw_text(_detail_x, _py + 94, "DETALHES");

draw_set_color(c_white);
draw_text(_detail_x, _py + 122, _recipe.nome);

draw_set_color(c_gray);
draw_text_ext(
    _detail_x,
    _py + 148,
    _recipe.descricao,
    18,
    _detail_w
);

var _ingredients_y = _py + 205;

draw_set_color(make_color_rgb(255, 174, 68));
draw_text(_detail_x, _ingredients_y, "Ingredientes");

var _line_y = _ingredients_y + 30;

for (var _j = 0; _j < array_length(_recipe.ingredientes); _j++) {
    var _ing = _recipe.ingredientes[_j];
    var _item = global.itens[| _ing.id];
    var _have = procura_item_inventario(_ing.id);
    var _ok = (_have >= _ing.qtd);

    draw_sprite_ext(
        _item.spr,
        _item.frames,
        _detail_x + 16,
        _line_y + 12,
        0.48,
        0.48,
        0,
        c_white,
        1
    );

    draw_set_color(_ok ? c_lime : make_color_rgb(255, 92, 92));

    draw_text(
        _detail_x + 40,
        _line_y + 3,
        _item.nome
        + "  "
        + string(_have)
        + "/"
        + string(_ing.qtd)
    );

    _line_y += 34;
}

// Combustivel.
var _wood_item = global.itens[| ITENS.madeira];
var _wood_have = procura_item_inventario(ITENS.madeira);
var _wood_ok = (_wood_have >= _recipe.combustivel);

draw_sprite_ext(
    _wood_item.spr,
    _wood_item.frames,
    _detail_x + 16,
    _line_y + 16,
    0.48,
    0.48,
    0,
    c_white,
    1
);

draw_set_color(_wood_ok ? c_lime : make_color_rgb(255, 92, 92));
draw_text(
    _detail_x + 40,
    _line_y + 7,
    "Combustivel: Madeira  "
    + string(_wood_have)
    + "/"
    + string(_recipe.combustivel)
);

_line_y += 50;

// Resultado.
var _result_item = global.itens[| _recipe.resultado];

draw_set_color(make_color_rgb(255, 174, 68));
draw_text(_detail_x, _line_y, "Resultado");

draw_sprite_ext(
    _result_item.spr,
    _result_item.frames,
    _detail_x + 20,
    _line_y + 48,
    0.72,
    0.72,
    0,
    c_white,
    1
);

draw_set_color(c_white);
draw_text(
    _detail_x + 58,
    _line_y + 36,
    _result_item.nome + " x" + string(_recipe.quantidade)
);


// =====================================================
// ESTADO / PROGRESSO
// =====================================================

var _status_y = _py + _panel_h - 150;

draw_set_color(make_color_rgb(255, 174, 68));
draw_text(_px + 30, _status_y, "ESTADO DA FORNALHA");

var _progress = 0;

if (fornalha_state.active) {
    _progress = clamp(
        fornalha_state.progress / max(1, fornalha_state.duration),
        0,
        1
    );

    draw_set_color(c_white);
    draw_text(
        _px + 30,
        _status_y + 26,
        "Queimando... " + string(round(_progress * 100)) + "%"
    );
}
else if (fornalha_state.output_qty > 0) {
    draw_set_color(c_lime);
    draw_text(_px + 30, _status_y + 26, "Lote pronto para coleta.");
}
else {
    draw_set_color(c_gray);
    draw_text(_px + 30, _status_y + 26, "Parada.");
}

var _bar_x1 = _px + 30;
var _bar_y1 = _status_y + 54;
var _bar_x2 = _px + 350;
var _bar_y2 = _status_y + 76;

draw_set_color(make_color_rgb(48, 44, 52));
draw_rectangle(_bar_x1, _bar_y1, _bar_x2, _bar_y2, false);

draw_set_color(make_color_rgb(255, 118, 38));
draw_rectangle(
    _bar_x1 + 3,
    _bar_y1 + 3,
    _bar_x1 + 3 + (_bar_x2 - _bar_x1 - 6) * _progress,
    _bar_y2 - 3,
    false
);


// =====================================================
// BOTOES
// =====================================================

var _collect_x1 = _px + 385;
var _collect_y1 = _py + _panel_h - 83;
var _collect_x2 = _collect_x1 + 180;
var _collect_y2 = _py + _panel_h - 39;

var _smelt_x1 = _px + _panel_w - 230;
var _smelt_y1 = _py + _panel_h - 83;
var _smelt_x2 = _px + _panel_w - 35;
var _smelt_y2 = _py + _panel_h - 39;

var _collect_hover = point_in_rectangle(
    _mouse_x,
    _mouse_y,
    _collect_x1,
    _collect_y1,
    _collect_x2,
    _collect_y2
);

var _smelt_hover = point_in_rectangle(
    _mouse_x,
    _mouse_y,
    _smelt_x1,
    _smelt_y1,
    _smelt_x2,
    _smelt_y2
);

var _can_collect = (
    fornalha_state.output_qty > 0
    && fornalha_state.output_id >= 0
);

draw_set_color(
    _can_collect
        ? (_collect_hover ? c_lime : make_color_rgb(55, 120, 75))
        : make_color_rgb(50, 50, 56)
);

draw_rectangle(
    _collect_x1,
    _collect_y1,
    _collect_x2,
    _collect_y2,
    false
);

draw_set_halign(fa_center);
draw_set_color(_can_collect ? c_white : c_gray);
draw_text(
    (_collect_x1 + _collect_x2) * 0.5,
    _collect_y1 + 12,
    "COLETAR [SPACE]"
);

draw_set_color(
    fornalha_state.active
        ? make_color_rgb(70, 58, 54)
        : (_smelt_hover
            ? make_color_rgb(255, 154, 62)
            : make_color_rgb(177, 82, 40))
);

draw_rectangle(
    _smelt_x1,
    _smelt_y1,
    _smelt_x2,
    _smelt_y2,
    false
);

draw_set_color(fornalha_state.active ? c_gray : c_white);
draw_text(
    (_smelt_x1 + _smelt_x2) * 0.5,
    _smelt_y1 + 12,
    fornalha_state.active ? "TRABALHANDO..." : "FUNDIR [ENTER]"
);

draw_set_halign(fa_left);


// =====================================================
// MENSAGEM / CONTROLES
// =====================================================

if (string_length(ui_message) > 0) {
    draw_set_color(c_yellow);
    draw_text(_px + 30, _py + _panel_h - 108, ui_message);
}

draw_set_color(c_gray);
draw_text(
    _px + 30,
    _py + _panel_h - 28,
    "W/S: receita   ENTER: fundir   SPACE: coletar   F/ESC: fechar"
);

draw_set_alpha(1);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_font(-1);

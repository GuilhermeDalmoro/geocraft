if (!instance_exists(fornalha_ref)) exit;

var _gw = display_get_gui_width();
var _gh = display_get_gui_height();

var _recipes = fornalha_ref.receitas_fornalha;
var _state = fornalha_ref.fornalha_state;
selected = clamp(selected, 0, array_length(_recipes) - 1);

var _panel_w = min(820, _gw - 80);
var _panel_h = min(560, _gh - 80);
var _px = (_gw - _panel_w) * 0.5;
var _py = (_gh - _panel_h) * 0.5;

// Fundo / moldura pixelada.
draw_set_alpha(0.95);
draw_set_color(make_color_rgb(22, 18, 22));
draw_rectangle(_px, _py, _px + _panel_w, _py + _panel_h, false);

draw_set_alpha(1);
draw_set_color(make_color_rgb(255, 154, 62));
draw_rectangle(_px + 4, _py + 4, _px + _panel_w - 4, _py + _panel_h - 4, true);

draw_set_font(fnt_dialogo_small);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

draw_set_color(c_yellow);
draw_text(_px + 30, _py + 24, "FORNALHA CUBICA");

draw_set_color(c_white);
draw_text(_px + 30, _py + 52, "W/S: receita   ENTER: fundir   SPACE: coletar   F/ESC: fechar");

var _list_x = _px + 34;
var _list_y = _py + 105;

for (var _i = 0; _i < array_length(_recipes); _i++) {
    var _r = _recipes[_i];
    var _ry = _list_y + _i * 54;
    var _selected = (_i == selected);

    if (_selected) {
        draw_set_alpha(0.25);
        draw_set_color(c_white);
        draw_rectangle(_list_x - 10, _ry - 8, _px + 360, _ry + 34, false);
        draw_set_alpha(1);
    }

    draw_set_color(_selected ? c_aqua : c_white);
    draw_text(_list_x, _ry, (_selected ? "> " : "  ") + _r.nome);
}

var _recipe = _recipes[selected];
var _detail_x = _px + 400;

draw_set_color(c_yellow);
draw_text(_detail_x, _py + 105, "INGREDIENTES");

var _iy = _py + 138;

for (var _j = 0; _j < array_length(_recipe.ingredientes); _j++) {
    var _ing = _recipe.ingredientes[_j];
    var _have = procura_item_inventario(_ing.id);
    var _item = global.itens[| _ing.id];

    draw_set_color(_have >= _ing.qtd ? c_lime : c_red);
    draw_text(
        _detail_x,
        _iy,
        _item.nome + ": " + string(_have) + "/" + string(_ing.qtd)
    );

    _iy += 26;
}

var _wood = procura_item_inventario(ITENS.madeira);
draw_set_color(_wood >= 1 ? c_lime : c_red);
draw_text(_detail_x, _iy + 8, "Combustivel: Madeira " + string(_wood) + "/1");

draw_set_color(c_white);
draw_text(_detail_x, _iy + 42, "Resultado: " + global.itens[| _recipe.resultado].nome + " x" + string(_recipe.quantidade));

// Estado da maquina.
var _status_y = _py + _panel_h - 150;

draw_set_color(c_yellow);
draw_text(_px + 34, _status_y, "ESTADO");

if (_state.active) {
    var _p = clamp(_state.progress / max(1, _state.duration), 0, 1);

    draw_set_color(c_white);
    draw_text(_px + 34, _status_y + 28, "Queimando... " + string(round(_p * 100)) + "%");

    draw_set_color(make_color_rgb(60, 60, 70));
    draw_rectangle(_px + 34, _status_y + 58, _px + _panel_w - 34, _status_y + 82, false);

    draw_set_color(make_color_rgb(255, 130, 35));
    draw_rectangle(
        _px + 38,
        _status_y + 62,
        _px + 38 + (_panel_w - 76) * _p,
        _status_y + 78,
        false
    );
}
else {
    draw_set_color(c_gray);
    draw_text(_px + 34, _status_y + 28, "Parada - selecione uma receita e aperte ENTER");
}

if (_state.output_qty > 0 && _state.output_id >= 0) {
    var _out_item = global.itens[| _state.output_id];

    draw_set_color(c_lime);
    draw_text(
        _px + 34,
        _status_y + 94,
        "SAIDA PRONTA: " + _out_item.nome + " x" + string(_state.output_qty) + "  [SPACE]"
    );
}

draw_set_color(c_white);
draw_set_alpha(1);
draw_set_font(-1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

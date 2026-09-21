var _gw = display_get_gui_width();
var _gh = display_get_gui_height();

var _w = min(680, _gw - 60);
var _h = min(500, _gh - 60);
var _x = (_gw - _w) * 0.5;
var _y = (_gh - _h) * 0.5;

var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);

// Fundo.
draw_set_alpha(0.58);
draw_set_color(c_black);
draw_rectangle(0, 0, _gw, _gh, false);

draw_set_alpha(0.98);
draw_set_color(make_color_rgb(21, 19, 31));
draw_rectangle(_x, _y, _x + _w, _y + _h, false);

draw_set_alpha(1);
draw_set_color(make_color_rgb(255, 125, 190));
draw_rectangle(_x + 3, _y + 3, _x + _w - 3, _y + _h - 3, true);

draw_set_font(fnt_geocraft);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

draw_set_color(make_color_rgb(255, 125, 190));
draw_text(_x + 28, _y + 22, "LOJA DE CUBIC-LAND");

draw_set_font(fnt_dialogo_small);

draw_set_color(c_white);
draw_text(_x + 30, _y + 66, "Moedas: " + string(global.moedas));

draw_set_color(c_gray);
draw_text(_x + 30, _y + 88, "W/S: escolher   ENTER/clique: comprar   F/ESC: sair");

// X.
var _close_x1 = _x + _w - 52;
var _close_y1 = _y + 14;
var _close_x2 = _x + _w - 18;
var _close_y2 = _y + 46;

var _close_hover = point_in_rectangle(
    _mx,
    _my,
    _close_x1,
    _close_y1,
    _close_x2,
    _close_y2
);

draw_set_color(
    _close_hover
        ? make_color_rgb(255, 95, 95)
        : make_color_rgb(80, 48, 62)
);
draw_rectangle(_close_x1, _close_y1, _close_x2, _close_y2, false);

draw_set_halign(fa_center);
draw_set_color(c_white);
draw_text((_close_x1 + _close_x2) * 0.5, _close_y1 + 7, "X");
draw_set_halign(fa_left);

// Itens.
var _start_y = _y + 118;
var _row_h = 52;
var _list_x1 = _x + 28;
var _list_x2 = _x + _w - 28;

for (var _i = 0; _i < array_length(itens_venda); _i++) {
    var _sale = itens_venda[_i];
    var _row_y = _start_y + _i * _row_h;

    var _hover = point_in_rectangle(
        _mx,
        _my,
        _list_x1,
        _row_y,
        _list_x2,
        _row_y + 44
    );

    var _selected = (_i == index);
    var _item = global.itens[| _sale.id];

    draw_set_alpha(_selected ? 0.90 : (_hover ? 0.68 : 0.38));
    draw_set_color(
        _selected
            ? make_color_rgb(67, 45, 67)
            : make_color_rgb(37, 35, 47)
    );

    draw_rectangle(
        _list_x1,
        _row_y,
        _list_x2,
        _row_y + 44,
        false
    );

    draw_set_alpha(1);

    if (_selected) {
        draw_set_color(make_color_rgb(255, 125, 190));
        draw_rectangle(
            _list_x1 + 2,
            _row_y + 2,
            _list_x2 - 2,
            _row_y + 42,
            true
        );
    }

    draw_sprite_ext(
        _item.spr,
        _item.frames,
        _list_x1 + 28,
        _row_y + 22,
        0.50,
        0.50,
        0,
        c_white,
        1
    );

    draw_set_color(_selected ? c_yellow : c_white);
    draw_text(_list_x1 + 58, _row_y + 7, _sale.nome);

    draw_set_halign(fa_right);
    draw_set_color(
        global.moedas >= _sale.preco
            ? c_lime
            : make_color_rgb(255, 95, 95)
    );
    draw_text(_list_x2 - 18, _row_y + 7, string(_sale.preco) + " moedas");

    draw_set_halign(fa_left);
    draw_set_color(c_gray);
    draw_text_ext(
        _list_x1 + 58,
        _row_y + 25,
        _item.desc,
        16,
        _w - 260
    );
}

draw_set_color(c_gray);
draw_text(
    _x + 30,
    _y + _h - 40,
    "Compras vao direto para o inventario. O capitalismo cubico agradece."
);

draw_set_alpha(1);
draw_set_color(c_white);
draw_set_font(-1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

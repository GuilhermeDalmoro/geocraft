var _gw = display_get_gui_width();
var _gh = display_get_gui_height();

var _w = min(560, _gw - 80);
var _h = min(420, _gh - 80);
var _x = (_gw - _w) * 0.5;
var _y = (_gh - _h) * 0.5;

draw_set_alpha(0.94);
draw_set_color(make_color_rgb(20, 18, 30));
draw_rectangle(_x, _y, _x + _w, _y + _h, false);
draw_set_alpha(1);

draw_set_font(fnt_dialogo_small);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

draw_set_color(c_yellow);
draw_text(_x + 28, _y + 22, "LOJA DE CUBIC-LAND");

draw_set_color(c_white);
draw_text(_x + 28, _y + 50, "Moedas: " + string(global.moedas));
draw_text(_x + 28, _y + 72, "W/S: escolher   ENTER: comprar   F/ESC: sair");

var _start_y = _y + 112;

for (var _i = 0; _i < array_length(itens_venda); _i++) {
    var _sale = itens_venda[_i];
    var _selected = (_i == index);
    var _iy = _start_y + _i * 48;

    if (_selected) {
        draw_set_alpha(0.28);
        draw_set_color(c_white);
        draw_rectangle(_x + 22, _iy - 6, _x + _w - 22, _iy + 34, false);
        draw_set_alpha(1);
    }

    draw_set_color(_selected ? c_aqua : c_white);
    draw_text(
        _x + 36,
        _iy,
        (_selected ? "> " : "  ")
        + _sale.nome
        + "  -  "
        + string(_sale.preco)
        + " moedas"
    );
}

draw_set_color(c_gray);
draw_text(_x + 28, _y + _h - 42, "Compras vao direto para o inventario.");

draw_set_color(c_white);
draw_set_alpha(1);
draw_set_font(-1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

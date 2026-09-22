var _gw = display_get_gui_width();
var _gh = display_get_gui_height();

var _panel_x = 24;
var _panel_y = 22;
var _panel_w = _gw - 48;
var _panel_h = _gh - 44;

// Fundo.
draw_set_alpha(0.78);
draw_set_color(c_black);
draw_rectangle(0, 0, _gw, _gh, false);

draw_set_alpha(0.98);
draw_set_color(make_color_rgb(13, 16, 24));
draw_rectangle(
    _panel_x,
    _panel_y,
    _panel_x + _panel_w,
    _panel_y + _panel_h,
    false
);

draw_set_alpha(1);

draw_set_color(make_color_rgb(255, 65, 180));
draw_rectangle(
    _panel_x + 2,
    _panel_y + 2,
    _panel_x + _panel_w - 2,
    _panel_y + _panel_h - 2,
    true
);

// Header.
draw_set_font(fnt_geocraft);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

draw_set_color(c_fuchsia);
draw_text(_panel_x + 18, _panel_y + 14, "GEOCRAFT DEV CONSOLE");

draw_set_font(fnt_dialogo_small);

draw_set_halign(fa_right);
draw_set_color(c_gray);
draw_text(
    _panel_x + _panel_w - 18,
    _panel_y + 20,
    "F9/ESC fecha | Q/E abas | W/S seleciona | A/D altera | SHIFT = x10"
);

draw_set_halign(fa_left);


// =====================================================
// TABS
// =====================================================

var _tab_x = _panel_x + 18;
var _tab_y = _panel_y + 58;
var _tab_gap = (_panel_w - 36) / array_length(tabs);

for (var _t = 0; _t < array_length(tabs); _t++) {
    var _x1 = _tab_x + _t * _tab_gap;
    var _x2 = _x1 + _tab_gap - 4;
    var _active = (_t == tab);

    draw_set_color(
        _active
            ? make_color_rgb(92, 36, 82)
            : make_color_rgb(33, 36, 48)
    );

    draw_rectangle(_x1, _tab_y, _x2, _tab_y + 32, false);

    if (_active) {
        draw_set_color(c_fuchsia);
        draw_rectangle(_x1 + 1, _tab_y + 1, _x2 - 1, _tab_y + 31, true);
    }

    draw_set_halign(fa_center);
    draw_set_color(_active ? c_yellow : c_white);
    draw_text((_x1 + _x2) * 0.5, _tab_y + 8, tabs[_t]);
}

draw_set_halign(fa_left);


// =====================================================
// ROWS
// =====================================================

var _count = dev_row_count();
var _row_x1 = _panel_x + 28;
var _row_x2 = _panel_x + _panel_w - 28;
var _row_y = _panel_y + 112;
var _row_h = 37;

if (_count <= 0) {
    draw_set_color(c_gray);
    draw_text(_row_x1, _row_y, "Nada para editar nesta aba.");
}
else {
    for (var _v = 0; _v < visible_rows; _v++) {
        var _row = scroll + _v;

        if (_row >= _count) break;

        var _y1 = _row_y + _v * _row_h;
        var _y2 = _y1 + 31;
        var _active = (_row == selected);

        draw_set_color(
            _active
                ? make_color_rgb(58, 42, 66)
                : make_color_rgb(25, 28, 38)
        );

        draw_rectangle(_row_x1, _y1, _row_x2, _y2, false);

        if (_active) {
            draw_set_color(make_color_rgb(255, 65, 180));
            draw_rectangle(_row_x1 + 1, _y1 + 1, _row_x2 - 1, _y2 - 1, true);
        }

        draw_set_color(_active ? c_yellow : c_white);
        draw_text(_row_x1 + 12, _y1 + 8, dev_label(_row));

        draw_set_halign(fa_right);
        draw_set_color(c_aqua);
        draw_text(_row_x2 - 172, _y1 + 8, dev_value(_row));

        // - button.
        draw_set_color(make_color_rgb(63, 55, 68));
        draw_rectangle(_row_x2 - 150, _y1 + 3, _row_x2 - 104, _y2 - 3, false);

        draw_set_halign(fa_center);
        draw_set_color(c_white);
        draw_text(_row_x2 - 127, _y1 + 8, "-");

        // Enter / action area.
        draw_set_color(make_color_rgb(45, 49, 64));
        draw_rectangle(_row_x2 - 98, _y1 + 3, _row_x2 - 56, _y2 - 3, false);

        draw_set_color(c_gray);
        draw_text(_row_x2 - 77, _y1 + 8, "OK");

        // + button.
        draw_set_color(make_color_rgb(63, 55, 68));
        draw_rectangle(_row_x2 - 50, _y1 + 3, _row_x2 - 4, _y2 - 3, false);

        draw_set_color(c_white);
        draw_text(_row_x2 - 27, _y1 + 8, "+");

        draw_set_halign(fa_left);
    }
}


// Scroll indicator.
if (_count > visible_rows) {
    var _bar_x = _panel_x + _panel_w - 12;
    var _bar_y1 = _row_y;
    var _bar_y2 = _row_y + visible_rows * _row_h - 6;

    draw_set_color(make_color_rgb(45, 48, 58));
    draw_rectangle(_bar_x, _bar_y1, _bar_x + 4, _bar_y2, false);

    var _ratio = scroll / max(1, _count - visible_rows);
    var _thumb_h = max(18, (_bar_y2 - _bar_y1) * (visible_rows / _count));
    var _thumb_y = _bar_y1 + (_bar_y2 - _bar_y1 - _thumb_h) * _ratio;

    draw_set_color(c_fuchsia);
    draw_rectangle(_bar_x, _thumb_y, _bar_x + 4, _thumb_y + _thumb_h, false);
}


// Footer.
draw_set_color(c_gray);
draw_text(
    _panel_x + 20,
    _panel_y + _panel_h - 26,
    "DEV MODE altera o estado ao vivo. Salve manualmente na aba SAVES quando quiser persistir."
);

draw_set_alpha(1);
draw_set_color(c_white);
draw_set_font(-1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

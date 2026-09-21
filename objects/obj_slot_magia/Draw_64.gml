if (!instance_exists(obj_sdash)) exit;

var _player = instance_find(obj_sdash, 0);
if (!_player.active) exit;
if (global.pause || global.dialogo_acontecendo) exit;

var _gw = display_get_gui_width();
var _gh = display_get_gui_height();

var _spacing = 42;
var _base_x = _gw - 28 - (num_slots - 1) * _spacing;
var _base_y = _gh - 34;

draw_set_font(fnt_dialogo_small);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

for (var _i = 0; _i < num_slots; _i++) {
    var _x = _base_x + _i * _spacing;
    var _y = _base_y;

    var _unlocked =
        is_array(global.tem_magia)
        && _i < array_length(global.tem_magia)
        && global.tem_magia[_i];

    var _selected = (global.magia_selecionada == _i);

    var _slot_scale = _selected ? 1.45 : 1.15;

    draw_sprite_ext(
        spr_slot,
        0,
        _x,
        _y,
        _slot_scale,
        _slot_scale,
        0,
        _unlocked ? c_white : make_color_rgb(90, 90, 105),
        _unlocked ? 1 : 0.55
    );

    if (_unlocked) {
        draw_sprite_ext(
            spr_icones_magia,
            _i,
            _x,
            _y,
            _selected ? 1.35 : 1.05,
            _selected ? 1.35 : 1.05,
            0,
            c_white,
            1
        );
    }
    else {
        draw_set_color(make_color_rgb(130, 130, 145));
        draw_text(_x, _y, "X");
    }

    // Numero do atalho.
    draw_set_color(_selected ? c_yellow : c_gray);
    draw_text(_x, _y + 23, string(_i + 1));
}

// Nome e cooldown da magia atual.
if (global.magia_selecionada != noone
&& global.magia_selecionada >= 0
&& global.magia_selecionada < num_slots) {

    var _slot = global.magia_selecionada;

    draw_set_halign(fa_right);
    draw_set_valign(fa_top);

    draw_set_color(c_yellow);
    draw_text(
        _gw - 18,
        _gh - 84,
        gc_magic_name(_slot) + "  [Z]"
    );

    var _max_cd = max(1, gc_magic_cooldown(_slot));
    var _cool = clamp(_player.magia_cooldown / _max_cd, 0, 1);

    var _bar_w = 170;
    var _bar_x = _gw - 18 - _bar_w;
    var _bar_y = _gh - 62;

    draw_set_color(make_color_rgb(38, 38, 50));
    draw_rectangle(
        _bar_x,
        _bar_y,
        _bar_x + _bar_w,
        _bar_y + 7,
        false
    );

    draw_set_color(
        _cool > 0
            ? make_color_rgb(105, 125, 170)
            : make_color_rgb(255, 125, 190)
    );

    draw_rectangle(
        _bar_x + 2,
        _bar_y + 2,
        _bar_x + 2 + (_bar_w - 4) * (1 - _cool),
        _bar_y + 5,
        false
    );
}

draw_set_alpha(1);
draw_set_color(c_white);
draw_set_font(-1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

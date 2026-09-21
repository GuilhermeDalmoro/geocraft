draw_self();

if (!instance_exists(obj_sdash)) exit;
if (global.dialogo_acontecendo) exit;
if (ui_open) exit;

var _player = instance_find(obj_sdash, 0);
var _dist = point_distance(x, y, _player.x, _player.y);

if (_dist <= 68) {
    draw_set_font(fnt_dialogo_small);
    draw_set_halign(fa_center);

    var _text = "[F] Usar fornalha";
    var _col = c_yellow;

    if (fornalha_state.output_qty > 0) {
        _text = "[F] Fornalha - item pronto!";
        _col = c_lime;
    }
    else if (fornalha_state.active) {
        var _p = round(
            clamp(
                fornalha_state.progress / max(1, fornalha_state.duration),
                0,
                1
            ) * 100
        );

        _text = "[F] Fornalha - " + string(_p) + "%";
        _col = make_color_rgb(255, 154, 62);
    }

    draw_set_color(c_black);
    draw_text(x + 1, y - 43 + 1, _text);

    draw_set_color(_col);
    draw_text(x, y - 43, _text);

    draw_set_halign(fa_left);
    draw_set_color(c_white);
    draw_set_font(-1);
}

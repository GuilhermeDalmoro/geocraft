draw_self();

if (!instance_exists(obj_sdash)) exit;

var _player = instance_find(obj_sdash, 0);
var _dist = point_distance(x, y, _player.x, _player.y);

if (_dist <= 56) {
    draw_set_font(fnt_dialogo_small);
    draw_set_halign(fa_center);

    var _text = "";

    if (montado && cavaleiro == _player) {
        _text = "[R] Desmontar";
    }
    else if (!alimentado) {
        _text = "[CTRL] Alimentar";
    }
    else if (!_player.montado && mount_cooldown <= 0) {
        _text = "[R] Montar";
    }

    if (string_length(_text) > 0) {
        draw_set_color(c_black);
        draw_text(x + 1, y - 39 + 1, _text);

        draw_set_color(c_yellow);
        draw_text(x, y - 39, _text);
    }

    draw_set_halign(fa_left);
    draw_set_color(c_white);
    draw_set_font(-1);
}

draw_self();

if (!instance_exists(obj_sdash)) exit;
if (global.dialogo_acontecendo) exit;

var _player = instance_find(obj_sdash, 0);
var _dist = point_distance(x, y, _player.x, _player.y);

if (_dist <= 56 && !instance_exists(obj_fornalha_ui)) {
    draw_set_font(fnt_dialogo_small);
    draw_set_halign(fa_center);

    draw_set_color(c_black);
    draw_text(x + 1, y - 43 + 1, "[F] Usar fornalha");

    draw_set_color(c_yellow);
    draw_text(x, y - 43, "[F] Usar fornalha");

    draw_set_halign(fa_left);
    draw_set_color(c_white);
    draw_set_font(-1);
}

draw_self();

if (!instance_exists(obj_sdash)) exit;
if (global.pause || global.dialogo_acontecendo) exit;

var _player = instance_find(obj_sdash, 0);

if (point_distance(x, y, _player.x, _player.y) <= 42) {
    draw_set_font(fnt_dialogo_small);
    draw_set_halign(fa_center);
    draw_set_color(c_yellow);
    draw_text(x, y - sprite_height * 0.6, "[F] Loja");
    draw_set_color(c_white);
    draw_set_halign(fa_left);
    draw_set_font(-1);
}

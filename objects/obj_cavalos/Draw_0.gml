draw_self();

if (!instance_exists(obj_sdash) || global.pause) exit;

var _q = gc_quest_get("alimentar_cavalos");

if (_q != noone
&& _q.status == "ativa"
&& !alimentado) {

    var _p = instance_find(obj_sdash, 0);

    if (point_distance(x, y, _p.x, _p.y) <= 54) {
        draw_set_font(fnt_dialogo_small);
        draw_set_halign(fa_center);

        draw_set_color(c_black);
        draw_text(x + 1, y - 38 + 1, "[CTRL] Alimentar");

        draw_set_color(c_yellow);
        draw_text(x, y - 38, "[CTRL] Alimentar");

        draw_set_color(c_white);
        draw_set_halign(fa_left);
        draw_set_font(-1);
    }
}

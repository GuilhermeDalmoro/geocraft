draw_self();

if (!montado && !alimentado && instance_exists(obj_sdash)) {
    var _dist = point_distance(x, y, obj_sdash.x, obj_sdash.y);

    if (_dist <= 34) {
        draw_set_font(fnt_dialogo_small);
        draw_set_halign(fa_center);
        draw_set_color(c_yellow);
        draw_text(x, y - 34, "CTRL - Alimentar");
        draw_set_halign(fa_left);
        draw_set_color(c_white);
    }
}

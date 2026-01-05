draw_set_color(c_white);
draw_rectangle(200, 500, 600, 520, false);
draw_set_color(c_green);
draw_rectangle(hit_zone - hit_window, 500, hit_zone + hit_window, 520, false);
draw_set_color(c_yellow);
draw_rectangle(barra_pos - 10, 500, barra_pos + 10, 520, false);
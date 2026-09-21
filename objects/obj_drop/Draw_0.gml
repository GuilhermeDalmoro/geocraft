//desenha_sombra();
draw_sprite_ext(sprite_index, image_index, x, y + z, image_xscale, image_yscale, image_angle, image_blend, image_alpha);

//draw_rectangle(bbox_left - 10, bbox_top - 10, bbox_right + 10, bbox_bottom +10, true)

draw_set_font(fnt_qtd_item);

draw_text(x, y  + z  + 4, qtd)

draw_set_font(-1);
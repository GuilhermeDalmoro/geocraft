if (cached_room != room) {
    cached_room = room;
    minimap_recalculate();
    minimap_build_surface();
}
else if (!surface_exists(map_surface)) {
    minimap_recalculate();
    minimap_build_surface();
}

// Posicao GUI pode mudar se resolucao/janela mudar.
minimap_x = display_get_gui_width() - minimap_width - minimap_margin;
minimap_y = display_get_gui_height() - minimap_height - minimap_margin;

if (surface_exists(map_surface)) {
    draw_set_alpha(1);
    draw_surface(map_surface, minimap_x, minimap_y);
}

// Marcadores dinamicos. Nao redesenha todos os sprites do jogo.
if (instance_exists(obj_sdash)) {
    var _p = instance_find(obj_sdash, 0);
    var _px = minimap_x + offset_x + _p.x * scale;
    var _py = minimap_y + offset_y + _p.y * scale;

    draw_set_color(c_yellow);
    draw_circle(_px, _py, 4, false);
}

with (obj_par_inimigos) {
    var _mx = other.minimap_x + other.offset_x + x * other.scale;
    var _my = other.minimap_y + other.offset_y + y * other.scale;
    draw_set_color(c_red);
    draw_rectangle(_mx - 2, _my - 2, _mx + 2, _my + 2, false);
}

with (obj_par_npc) {
    var _mx = other.minimap_x + other.offset_x + x * other.scale;
    var _my = other.minimap_y + other.offset_y + y * other.scale;
    draw_set_color(c_lime);
    draw_rectangle(_mx - 2, _my - 2, _mx + 2, _my + 2, false);
}

with (obj_npc_proc) {
    var _mx = other.minimap_x + other.offset_x + x * other.scale;
    var _my = other.minimap_y + other.offset_y + y * other.scale;
    draw_set_color(c_lime);
    draw_rectangle(_mx - 1, _my - 1, _mx + 1, _my + 1, false);
}

draw_set_color(c_white);
draw_set_alpha(1);

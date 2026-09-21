map_surface = -1;

if (instance_number(obj_minimap) > 1) {
    instance_destroy();
    exit;
}

// Minimap cacheado: tiles estaticos sao reconstruidos apenas ao trocar de room
// ou quando a surface for perdida.

minimap_width = 400;
minimap_height = 300;
minimap_margin = 10;

bg_color = c_black;
tile_color = make_color_rgb(160, 160, 160);
alpha = 0.70;

cached_room = -1;
map_surface = -1;

minimap_recalculate = function() {
    minimap_x = display_get_gui_width() - minimap_width - minimap_margin;
    minimap_y = display_get_gui_height() - minimap_height - minimap_margin;

    scale_x = minimap_width / max(1, room_width);
    scale_y = minimap_height / max(1, room_height);
    scale = min(scale_x, scale_y);

    offset_x = (minimap_width - room_width * scale) * 0.5;
    offset_y = (minimap_height - room_height * scale) * 0.5;
};

minimap_build_surface = function() {
    if (surface_exists(map_surface)) surface_free(map_surface);

    map_surface = surface_create(minimap_width, minimap_height);
    if (!surface_exists(map_surface)) return false;

    surface_set_target(map_surface);
    draw_clear_alpha(c_black, 0);

    draw_set_alpha(alpha);
    draw_set_color(bg_color);
    draw_rectangle(0, 0, minimap_width, minimap_height, false);
    draw_set_alpha(1);

    var _layers = layer_get_all();

    for (var _li = 0; _li < array_length(_layers); _li++) {
        var _tilemap = layer_tilemap_get_id(_layers[_li]);
        if (_tilemap == -1) continue;

        for (var _tx = 0; _tx < room_width; _tx += 32) {
            for (var _ty = 0; _ty < room_height; _ty += 32) {
                if (tilemap_get_at_pixel(_tilemap, _tx, _ty) == 0) continue;

                var _mx = offset_x + _tx * scale;
                var _my = offset_y + _ty * scale;

                draw_set_color(tile_color);
                draw_rectangle(
                    _mx,
                    _my,
                    _mx + 32 * scale,
                    _my + 32 * scale,
                    false
                );
            }
        }
    }

    draw_set_color(c_white);
    draw_set_alpha(1);
    surface_reset_target();

    cached_room = room;
    return true;
};

minimap_recalculate();

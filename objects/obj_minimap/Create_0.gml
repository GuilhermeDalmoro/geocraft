map_surface = -1;

if (instance_number(obj_minimap) > 1) {
    instance_destroy();
    exit;
}

// Minimap v5: radar local, compacto e cacheado.
cached_room = -1;

expanded = false;
map_visible = true;

compact_w = 236;
compact_h = 176;

expanded_w = 620;
expanded_h = 420;

panel_margin = 14;
header_h = 30;

surface_w = 0;
surface_h = 0;
map_scale_x = 1;
map_scale_y = 1;

map_rebuild = function() {
    if (surface_exists(map_surface)) {
        surface_free(map_surface);
        map_surface = -1;
    }

    var _max_surface = 512;
    var _surface_scale = min(
        _max_surface / max(1, room_width),
        _max_surface / max(1, room_height)
    );

    surface_w = max(64, round(room_width * _surface_scale));
    surface_h = max(64, round(room_height * _surface_scale));

    map_scale_x = surface_w / max(1, room_width);
    map_scale_y = surface_h / max(1, room_height);

    map_surface = surface_create(surface_w, surface_h);

    if (!surface_exists(map_surface)) {
        return false;
    }

    surface_set_target(map_surface);

    draw_clear_alpha(make_color_rgb(10, 13, 22), 1);

    var _layers = layer_get_all();

    for (var _li = 0; _li < array_length(_layers); _li++) {
        var _layer = _layers[_li];
        var _tilemap = layer_tilemap_get_id(_layer);

        if (_tilemap == -1) continue;

        var _layer_name = string_lower(layer_get_name(_layer));

        var _col = make_color_rgb(70, 76, 88);
        var _alpha = 0.20;

        if (string_pos("agua", _layer_name) > 0
        || string_pos("water", _layer_name) > 0) {
            _col = make_color_rgb(55, 116, 170);
            _alpha = 0.50;
        }
        else if (string_pos("parede", _layer_name) > 0
        || string_pos("wall", _layer_name) > 0
        || string_pos("colis", _layer_name) > 0
        || string_pos("rocha", _layer_name) > 0) {
            _col = make_color_rgb(185, 178, 188);
            _alpha = 0.78;
        }
        else if (string_pos("grama", _layer_name) > 0
        || string_pos("grass", _layer_name) > 0
        || string_pos("chao", _layer_name) > 0
        || string_pos("ground", _layer_name) > 0) {
            _col = make_color_rgb(74, 115, 82);
            _alpha = 0.28;
        }
        else if (string_pos("casa", _layer_name) > 0
        || string_pos("predio", _layer_name) > 0
        || string_pos("building", _layer_name) > 0) {
            _col = make_color_rgb(182, 128, 102);
            _alpha = 0.60;
        }

        draw_set_color(_col);
        draw_set_alpha(_alpha);

        // 32 px casa bem com o tileset atual e so acontece ao reconstruir o cache.
        for (var _tx = 0; _tx < room_width; _tx += 32) {
            for (var _ty = 0; _ty < room_height; _ty += 32) {
                if (tilemap_get_at_pixel(_tilemap, _tx, _ty) == 0) continue;

                var _mx = _tx * map_scale_x;
                var _my = _ty * map_scale_y;

                draw_rectangle(
                    _mx,
                    _my,
                    _mx + max(1, 32 * map_scale_x),
                    _my + max(1, 32 * map_scale_y),
                    false
                );
            }
        }
    }

    // Colisoes importantes ajudam a dar forma ao mapa mesmo quando a room
    // usa um tile layer de chao que cobre tudo.
    draw_set_alpha(0.75);
    draw_set_color(make_color_rgb(210, 202, 215));

    with (obj_parede) {
        var _mx1 = bbox_left * other.map_scale_x;
        var _my1 = bbox_top * other.map_scale_y;
        var _mx2 = bbox_right * other.map_scale_x;
        var _my2 = bbox_bottom * other.map_scale_y;

        draw_rectangle(_mx1, _my1, _mx2, _my2, false);
    }

    draw_set_alpha(1);
    draw_set_color(c_white);

    surface_reset_target();

    cached_room = room;
    return true;
};

map_rebuild();

// Draw GUI Event
// Desenha o minimapa na interface, mostrando todos os tilemaps e objetos visíveis

// Desenha o fundo do minimapa
draw_set_alpha(alpha);
draw_rectangle_color(minimap_x, minimap_y, minimap_x + minimap_width, minimap_y + minimap_height, 
                    bg_color, bg_color, bg_color, bg_color, false);
draw_set_alpha(1);

// Obtém todos os layers da room
var layers = layer_get_all();

// Itera sobre os layers pra desenhar todos os tilemaps
for (var i = 0; i < array_length(layers); i++) {
    var tilemap = layer_tilemap_get_id(layers[i]);
    if (tilemap != -1) { // Verifica se o layer tem um tilemap
        // Itera sobre a room em incrementos (32 pixels, tamanho padrão de tile)
        for (var tx = 0; tx < room_width; tx += 32) {
            for (var ty = 0; ty < room_height; ty += 32) {
                // Verifica se há um tile na posição
                var tile = tilemap_get_at_pixel(tilemap, tx, ty);
                if (tile != 0) {
                    // Calcula posição no minimapa, com offset pra centralizar
                    var mx = minimap_x + offset_x + (tx * scale);
                    var my = minimap_y + offset_y + (ty * scale);
                    // Desenha um retângulo representando o tile
                    draw_set_color(tile_color); // Cinza claro
                    draw_set_alpha(1); // Tiles com opacidade total
                    draw_rectangle(mx, my, mx + (32 * scale), my + (32 * scale), false);
                }
            }
        }
    }
}

// Restaura opacidade padrão
draw_set_alpha(alpha);

// Desenha os objetos visíveis da room
with (all) {
    // Só desenha se o objeto é visível e tem um sprite válido
    if (visible && sprite_exists(sprite_index)) {
        // Calcula posição no minimapa, com offset
        var mx = other.minimap_x + other.offset_x + (x * other.scale);
        var my = other.minimap_y + other.offset_y + (y * other.scale);
        // Desenha o sprite com escala e transparência
        draw_sprite_ext(sprite_index, image_index, mx, my, other.scale * 0.6, other.scale * 0.6, 0, c_white, other.alpha);
    }
}

// Restaura cor e opacidade padrão
draw_set_color(c_white);
draw_set_alpha(1);
part_sys = part_system_create();
part_type = part_type_create();
part_type_sprite(part_type, sprite_index, false, false, false);
part_type_alpha3(part_type, 0, 0.3, 0); // Fade in/out mais suave
part_type_scale(part_type, 4.5, 4.5); // Mais ampla
part_type_life(part_type, 60, 120); // Vive 1-2s pra raios lentos
part_type_speed(part_type, 0.05, 0.15, 0, 0); // Mais lento
part_type_direction(part_type, 0, 360, 0, 0); // Espalha como raios
part_type_blend(part_type, true); // Brilho aditivo
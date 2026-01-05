if (distance_to_object(obj_sdash) < 5 && keyboard_check_pressed(ord("G"))) {
    vida -= 1;
    sprite_index = spr_bloco_terra_quebrando; // Muda pro sprite de quebra
    image_speed = 0.2; // Animação
    if (vida <= 0) {
       instance_destroy(); // Remove o bloco
    }
}
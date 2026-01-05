if (global.comeca_batalha && global.turno == 1 && !instance_exists(obj_dialogo)) {
    ataque_timer += 1;
    if (ataque_timer >= 60) { // Delay de 1 segundo (60 frames)
        scr_ataques_boss(nome_boss, ataque_id, fase_ataque, ataque_timer)
        ataque_timer = 0; // Reseta timer
    }
    image_index += 0.2; // Animação
   // scr_particle_effects("spark", x, y, 10, c_red);
}
if (vida <= 0) {
   // scr_particle_effects("explosion", x, y, 20, c_white);
    instance_destroy();
    room_goto_previous();
}
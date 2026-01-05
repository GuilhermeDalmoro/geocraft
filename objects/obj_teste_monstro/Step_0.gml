if (global.comeca_batalha && global.turno == 1 && !instance_exists(obj_dialogo)) {
    ataque_timer += 1;
    scr_ataques_boss(self, ataque_id, fase_ataque, ataque_timer);
    image_index += 0.2; // Balança
    y += sin(current_time * 0.005) * 2; // Movimento suave
    //scr_particle_effects("spark", x, y, 5, c_red);
}
if (vida <= 0) {
    //scr_particle_effects("explosion", x, y, 20, c_white);
    instance_destroy();
    room_goto_previous();
}
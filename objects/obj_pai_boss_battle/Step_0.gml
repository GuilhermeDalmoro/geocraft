if (global.comeca_batalha && global.turno == 1 && !instance_exists(obj_dialogo)) {
    ataque_timer += 1;

    // O script de ataque controla os proprios thresholds (1, 60, 120, 180...).
    // Antes o timer era resetado a cada 60 frames e varias fases nunca terminavam.
    scr_ataques_boss(id, ataque_id, fase_ataque, ataque_timer);

    image_index += 0.2;
}

if (vida <= 0) {
    instance_destroy();
    room_goto_previous();
}

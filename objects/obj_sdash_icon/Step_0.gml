if (global.batalha_menu == -1 && global.comeca_batalha && global.turno == 1 && !instance_exists(obj_dialogo)) {
    if keyboard_check(ord("W")) y -= global.velocidade_arena_sdash;
    if keyboard_check(ord("A")) x -= global.velocidade_arena_sdash;
    if keyboard_check(ord("S")) y += global.velocidade_arena_sdash;
    if keyboard_check(ord("D")) x += global.velocidade_arena_sdash;
}

if (global.invframes > 0) {
    global.invframes -= 1;
    image_speed = 1;
} else {
    image_speed = 0;
    image_index = 0;
}

if (global.turno == 0 && global.batalha_menu == -1 && !instance_exists(obj_dialogo)) {
    image_index += 0.3; // Animação de ataque
   // scr_particle_effects("explosion", x, y, 5, c_yellow);
}
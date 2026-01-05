if (global.invframes <= 0 && global.turno == 1) {
    global.invframes = 30;
    global.vida_arena_sdash -= dano;
    if (global.vida_arena_sdash <= 0) {
        game_restart(); // Ajuste pra checkpoint
    }
}
if (desaparecer) {
    instance_destroy();
}
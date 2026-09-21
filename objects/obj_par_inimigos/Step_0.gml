/// Controle base dos inimigos.

depth = -y;

if (global.pause) exit;

// Stun agora realmente interrompe IA/movimento.
var _stunned = false;

if (stun_timer > 0) {
    stun_timer--;
    _stunned = true;
}

if (!_stunned) {
    script_execute(estado);
}

// Queimadura continua causando dano enquanto o jogo roda.
if (queimando) {
    if (queima_timer > 0) {
        queima_timer--;
        queima_accum++;

        if (queima_accum >= max(1, queima_tick)) {
            queima_accum = 0;

            if (variable_instance_exists(id, "vida")) {
                vida -= queima_dps;
            }
        }
    }
    else {
        queimando = false;
    }
}

if (vida <= 0) {
    global.inimigos_mortos += 1;
    gc_game_state_sync_from_legacy();
    gc_quest_notify("matar", "inimigo", 1);

    instance_destroy();
    exit;
}

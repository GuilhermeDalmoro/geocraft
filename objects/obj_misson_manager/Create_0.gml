/// Bootstrap central da campanha.
/// Este objeto ja era persistente e aparece em mais de uma room.
/// Se uma room tentar criar uma segunda copia, mantemos apenas o singleton antigo.
if (instance_number(obj_misson_manager) > 1) {
    instance_destroy();
    exit;
}

gc_game_state_bootstrap();

// Compatibilidade: global.missoes aponta para os mesmos structs guardados no GameState.
global.missoes = global.game_state.missions;

// Mantem a intencao do prototipo antigo: a missao de teste comeca ativa.
// Agora passamos o ID correto (antes era passado o struct inteiro por engano).
var _m = scr_missoes_pegar("teste");
if (_m != noone && _m.status == "bloqueada") {
    scr_missoes_iniciar("teste");
}

gc_game_state_sync_from_legacy();
gc_game_state_debug_print();

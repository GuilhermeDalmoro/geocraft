// Ponte temporaria entre os sistemas antigos e o GameState.
// Enquanto dialogos, bosses e rooms ainda escrevem diretamente em global.*,
// capturamos essas mudancas aqui sem quebrar conteudo existente.
if (variable_global_exists("game_state") && is_struct(global.game_state)) {
    gc_game_state_sync_from_legacy();
}

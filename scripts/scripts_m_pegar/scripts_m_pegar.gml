function scr_missoes_pegar(_id) {
    if (!variable_global_exists("missoes") || !is_array(global.missoes)) {
        if (variable_global_exists("game_state") && is_struct(global.game_state)) {
            global.missoes = global.game_state.missions;
        } else {
            global.missoes = scr_missoes_banco();
        }
    }

    return gc_quest_get(_id);
}

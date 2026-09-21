function scr_missoes_pegar(_id) {
    if (!variable_global_exists("missoes") || !is_array(global.missoes)) {
        if (variable_global_exists("game_state") && is_struct(global.game_state)) {
            global.missoes = global.game_state.missions;
        } else {
            global.missoes = scr_missoes_banco();
        }
    }

    for (var _i = 0; _i < array_length(global.missoes); _i++) {
        var _m = global.missoes[_i];
        if (is_struct(_m) && _m.id_m == _id) {
            return _m;
        }
    }

    return noone;
}

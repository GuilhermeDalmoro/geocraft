function scr_missoes_iniciar(_missao_ou_id) {
    var _m = noone;

    // Compatibilidade com chamadas antigas que possam enviar o struct da missao.
    if (is_struct(_missao_ou_id)) {
        _m = _missao_ou_id;
    } else {
        _m = scr_missoes_pegar(_missao_ou_id);
    }

    if (_m == noone || !is_struct(_m)) {
        show_debug_message("[MISSAO] Nao foi possivel iniciar: " + string(_missao_ou_id));
        return false;
    }

    _m.status = "ativa";

    if (variable_global_exists("game_state") && is_struct(global.game_state)) {
        global.game_state.missions = global.missoes;
    }

    show_debug_message("[MISSAO] Ativada: " + string(_m.id_m));
    return true;
}

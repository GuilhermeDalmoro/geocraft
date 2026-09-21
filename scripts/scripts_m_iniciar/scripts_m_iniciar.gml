function scr_missoes_iniciar(_missao_ou_id) {
    var _id = _missao_ou_id;

    if (is_struct(_missao_ou_id)) {
        if (!variable_struct_exists(_missao_ou_id, "id_m")) return false;
        _id = _missao_ou_id.id_m;
    }

    return gc_quest_start(_id);
}

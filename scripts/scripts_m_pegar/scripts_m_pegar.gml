function scr_missoes_pegar(id) {
    for (var i = 0; i < array_length(global.missoes); i++) {
        if (global.missoes[i].id_m == id) {
            return global.missoes[i];
        }
    }
    return noone;
}

function scr_missoes_iniciar(id) {
    
    //show_message("scr_missoes_iniciar CHAMADO")
    
    var _m = scr_missoes_pegar(id);
    if (_m == noone) return;

    _m.status = "ativa";
    //show_message("Missão ativada: " + _m.id_m);
}


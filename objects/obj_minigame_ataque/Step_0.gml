barra_pos += barra_speed;
if (barra_pos >= 600) {
    barra_pos = 0; // Reseta barra
}
if (keyboard_check_pressed(vk_space)) {
    var _dano = 0;
    if (abs(barra_pos - hit_zone) <= hit_window) {
        _dano = dano_base * (1 - abs(barra_pos - hit_zone) / hit_window);
    //   scr_particle_effects("explosion", global.inimigo[0] ? global.inimigo[0].x : x, global.inimigo[0] ? global.inimigo[0].y : y, 10, c_yellow);
    }
    if (instance_exists(global.inimigo[0])) {
        global.inimigo[0].vida -= _dano;
        show_debug_message("Dano aplicado: " + string(_dano) + ", Vida do boss: " + string(global.inimigo[0].vida));
    } else {
        show_debug_message("Erro: global.inimigo[0] não existe!");
    }
    var _dialogo = instance_create_layer(0, 0, "Instances", obj_dialogo);
    _dialogo.npc_nome = "sdash_atacar";
    _dialogo.ativo = true;
    global.batalha_menu = -1;
    global.turno = 1;
    instance_destroy();
}
if (global.comeca_batalha && global.turno == 0 && !instance_exists(obj_dialogo)) {
    global.batalha_menu = 0;
    if (keyboard_check_pressed(vk_left)) global.ui_selecao_menu = max(0, global.ui_selecao_menu - 1);
    if (keyboard_check_pressed(vk_right)) global.ui_selecao_menu = min(array_length(opcoes) - 1, global.ui_selecao_menu + 1);
    opcao_selecionada = global.ui_selecao_menu;

    if (keyboard_check_pressed(vk_enter)) {
        switch (opcao_selecionada) {
            case 0: // Atacar (inicia minigame)
                global.batalha_menu = 1;
                var _minigame = instance_create_layer(0, 0, "Instances", obj_minigame_ataque);
                break;
            case 1: // Item
                if (global.item_batalha[global.ui_selecao_menu] == "Elixir") {
                    global.vida_arena_sdash = min(global.vida_arena_sdash + 10, 20);
                    //scr_particle_effects("spark", obj_sdash_icon.x, obj_sdash_icon.y, 5, c_green);
                }
                global.batalha_menu = -1;
                global.turno = 1;
                break;
            case 2: // Poupar
                if (global.inimigo[0].pode_poupar) {
                    room_goto_previous();
                } else {
                    var _dialogo = instance_create_layer(0, 0, "Instances", obj_dialogo);
                    _dialogo.npc_nome = "teste_nao_poupar";
                    _dialogo.ativo = true;
                }
                global.batalha_menu = -1;
                global.turno = 1;
                break;
            case 3: // Fugir
                if (global.pode_fugir) {
                    room_goto_previous();
                }
                global.batalha_menu = -1;
                global.turno = 1;
                break;
        }
    }
}
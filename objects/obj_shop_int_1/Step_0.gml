if (fechando) exit;

var _count = array_length(itens_venda);

var _move =
    keyboard_check_pressed(ord("S"))
    + keyboard_check_pressed(vk_down)
    - keyboard_check_pressed(ord("W"))
    - keyboard_check_pressed(vk_up);

if (_move != 0) {
    index = clamp(index + sign(_move), 0, _count - 1);
    tocar_som_efeito(snd_blip_select, 1, 1);
}

if (keyboard_check_pressed(vk_enter)
|| gamepad_button_check_pressed(global.controle, gp_face1)) {

    var _sale = itens_venda[index];

    if (global.moedas < _sale.preco) {
        gc_quest_toast("Moedas insuficientes", 80);
        tocar_som_efeito(snd_blim, 1, 0.9);
    }
    else {
        if (adiciona_ao_inventario(_sale.id, 1)) {
            global.moedas -= _sale.preco;
            gc_game_state_sync_from_legacy();

            gc_quest_notify("comprar", string(_sale.id), 1);
            gc_quest_notify("comprar", _sale.nome, 1);

            gc_quest_toast(
                "Comprou " + _sale.nome + " por " + string(_sale.preco) + " moedas",
                90
            );

            tocar_som_efeito(snd_blip_2, 1, 1.1);
        }
        else {
            gc_quest_toast("Inventario cheio", 90);
        }
    }
}

if (keyboard_check_pressed(vk_escape)
|| keyboard_check_pressed(ord("F"))
|| gamepad_button_check_pressed(global.controle, gp_face2)) {

    fechando = true;
    global.pause = false;

    if (variable_global_exists("game_state") && is_struct(global.game_state)) {
        global.game_state.runtime.pause = false;
    }

    instance_destroy();
}

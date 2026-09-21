if (!instance_exists(obj_sdash)) {
    inventario = false;
    global.pause_por_inventario = false;
    exit;
}

var _sdash = instance_find(obj_sdash, 0);

if (!_sdash.active) exit;

var _toggle_inv =
    keyboard_check_pressed(ord("E"))
    || gamepad_button_check_pressed(global.controle, gp_face4);

if (_toggle_inv && !global.dialogo_acontecendo) {
    if (inventario) {
        // Fechar sempre e permitido porque este inventario e o dono do pause.
        inventario = false;
        global.pause = false;
        global.pause_por_inventario = false;

        if (variable_global_exists("game_state") && is_struct(global.game_state)) {
            global.game_state.runtime.pause = false;
            global.game_state.runtime.pause_por_inventario = false;
        }

        tocar_som_efeito(snd_blip_2, 1, 0.95);
    }
    else {
        var _modal_busy = false;

        if (variable_global_exists("game_state") && is_struct(global.game_state)) {
            if (variable_struct_exists(global.game_state.runtime, "modal_ui")) {
                _modal_busy = (string_length(global.game_state.runtime.modal_ui) > 0);
            }
        }

        // Nao abre inventario por cima de pause, loja, fornalha ou diario.
        if (!global.pause && !_modal_busy) {
            inventario = true;
            global.pause = true;
            global.pause_por_inventario = true;

            if (variable_global_exists("game_state") && is_struct(global.game_state)) {
                global.game_state.runtime.pause = true;
                global.game_state.runtime.pause_por_inventario = true;
            }

            tocar_som_efeito(snd_blip_2, 1, 1);
        }
    }
}

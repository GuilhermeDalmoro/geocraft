if (!instance_exists(fornalha_ref)) {
    global.pause = false;

    if (variable_global_exists("game_state") && is_struct(global.game_state)) {
        global.game_state.runtime.pause = false;
    }

    instance_destroy();
    exit;
}

var _recipes = fornalha_ref.receitas_fornalha;
var _state = fornalha_ref.fornalha_state;
var _count = array_length(_recipes);

var _move =
    keyboard_check_pressed(ord("S"))
    + keyboard_check_pressed(vk_down)
    - keyboard_check_pressed(ord("W"))
    - keyboard_check_pressed(vk_up);

if (_move != 0) {
    selected = clamp(selected + sign(_move), 0, _count - 1);
    tocar_som_efeito(snd_blip_select, 1, 1);
}

if (keyboard_check_pressed(vk_enter)
|| gamepad_button_check_pressed(global.controle, gp_face1)) {

    var _recipe = _recipes[selected];

    if (_state.active) {
        gc_quest_toast("A fornalha ja esta trabalhando", 80);
    }
    else if (_state.output_qty > 0 && _state.output_id != _recipe.resultado) {
        gc_quest_toast("Colete a saida atual primeiro", 90);
    }
    else {
        var _can_start = true;
        var _wood_needed = 1; // combustivel

        for (var _i = 0; _i < array_length(_recipe.ingredientes); _i++) {
            var _ing = _recipe.ingredientes[_i];

            if (_ing.id == ITENS.madeira) {
                _wood_needed += _ing.qtd;
            }
            else if (procura_item_inventario(_ing.id) < _ing.qtd) {
                _can_start = false;
            }
        }

        if (procura_item_inventario(ITENS.madeira) < _wood_needed) {
            _can_start = false;
        }

        if (!_can_start) {
            gc_quest_toast("Faltam ingredientes ou madeira para combustivel", 100);
        }
        else {
            for (var _i = 0; _i < array_length(_recipe.ingredientes); _i++) {
                var _ing = _recipe.ingredientes[_i];
                remove_do_inventario(_ing.id, _ing.qtd);
            }

            // 1 madeira = 1 carga de combustivel por lote.
            remove_do_inventario(ITENS.madeira, 1);

            _state.active = true;
            _state.recipe_id = selected;
            _state.progress = 0;
            _state.duration = _recipe.duracao;

            if (_state.output_id == -1) {
                _state.output_id = _recipe.resultado;
            }

            gc_quest_toast("Fornalha acesa: " + _recipe.nome, 100);
            tocar_som_efeito(snd_blip_2, 1, 1);
        }
    }
}

// SPACE coleta toda a saida pronta.
if (keyboard_check_pressed(vk_space) && _state.output_qty > 0) {
    if (adiciona_ao_inventario(_state.output_id, _state.output_qty)) {
        var _qty = _state.output_qty;

        _state.output_id = -1;
        _state.output_qty = 0;

        gc_quest_toast("Coletou " + string(_qty) + " item(ns) da fornalha", 90);
        tocar_som_efeito(snd_blip_2, 1, 1.1);
    }
    else {
        gc_quest_toast("Inventario cheio", 90);
    }
}

if (keyboard_check_pressed(vk_escape)
|| keyboard_check_pressed(ord("F"))
|| gamepad_button_check_pressed(global.controle, gp_face2)) {

    global.pause = false;

    if (variable_global_exists("game_state") && is_struct(global.game_state)) {
        global.game_state.runtime.pause = false;
    }

    instance_destroy();
}

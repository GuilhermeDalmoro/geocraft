if (!is_struct(fornalha_state)) {
    fornalha_state = gc_world_furnace_get(room_get_name(room), x, y, true);
}

// Processamento continua mesmo com a interface aberta.
if (fornalha_state.active) {
    fornalha_state.progress++;

    sprite_index = spr_fornalha;

    if (fornalha_state.progress >= fornalha_state.duration) {
        var _recipe = noone;

        if (fornalha_state.recipe_id >= 0
        && fornalha_state.recipe_id < array_length(receitas_fornalha)) {
            _recipe = receitas_fornalha[fornalha_state.recipe_id];
        }

        if (is_struct(_recipe)) {
            if (fornalha_state.output_id == -1
            || fornalha_state.output_id == _recipe.resultado) {
                fornalha_state.output_id = _recipe.resultado;
                fornalha_state.output_qty += _recipe.quantidade;
                fornalha_state.total_batches++;

                gc_state_counter_add("itens_fundidos", _recipe.quantidade);
                gc_state_counter_add("fundido_" + string(_recipe.resultado), _recipe.quantidade);
                gc_quest_notify("fundir", string(_recipe.resultado), _recipe.quantidade);
            }
        }

        fornalha_state.active = false;
        fornalha_state.recipe_id = -1;
        fornalha_state.progress = 0;
        fornalha_state.duration = 0;

        gc_quest_toast("Fornalha terminou o processamento", 100);
    }
}
else {
    sprite_index = spr_fornalha_fechada;
}

if (!instance_exists(obj_sdash)) exit;

var _player = instance_find(obj_sdash, 0);
var _dist = point_distance(x, y, _player.x, _player.y);

if (_dist <= 48
&& !global.pause
&& !global.dialogo_acontecendo
&& !instance_exists(obj_fornalha_ui)
&& (keyboard_check_pressed(ord("F"))
    || gamepad_button_check_pressed(global.controle, gp_face2))) {

    var _ui = instance_create_depth(0, 0, -100000, obj_fornalha_ui);
    _ui.fornalha_ref = id;

    global.pause = true;

    if (variable_global_exists("game_state") && is_struct(global.game_state)) {
        global.game_state.runtime.pause = true;
    }
}

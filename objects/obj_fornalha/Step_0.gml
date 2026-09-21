if (!is_struct(fornalha_state)) {
    fornalha_state = gc_world_furnace_get(room_get_name(room), x, y, true);
}

if (ui_message_timer > 0) {
    ui_message_timer--;
}
else {
    ui_message = "";
}

if (ui_open_lock > 0) {
    ui_open_lock--;
}

// =====================================================
// PROCESSAMENTO DA MAQUINA
// =====================================================

var _can_process = !global.pause || ui_open;

if (fornalha_state.active && _can_process) {
    fornalha_state.progress++;
    sprite_index = spr_fornalha;

    if (fornalha_state.progress >= max(1, fornalha_state.duration)) {
        var _recipe_done = noone;

        if (fornalha_state.recipe_id >= 0
        && fornalha_state.recipe_id < array_length(receitas_fornalha)) {
            _recipe_done = receitas_fornalha[fornalha_state.recipe_id];
        }

        if (is_struct(_recipe_done)) {
            if (fornalha_state.output_id == -1
            || fornalha_state.output_id == _recipe_done.resultado) {

                fornalha_state.output_id = _recipe_done.resultado;
                fornalha_state.output_qty += _recipe_done.quantidade;
                fornalha_state.total_batches++;

                gc_state_counter_add("itens_fundidos", _recipe_done.quantidade);
                gc_state_counter_add(
                    "fundido_" + string(_recipe_done.resultado),
                    _recipe_done.quantidade
                );

                gc_quest_notify(
                    "fundir",
                    string(_recipe_done.resultado),
                    _recipe_done.quantidade
                );
            }
        }

        fornalha_state.active = false;
        fornalha_state.recipe_id = -1;
        fornalha_state.progress = 0;
        fornalha_state.duration = 0;

        ui_message = "Processamento concluido!";
        ui_message_timer = 180;

        if (!ui_open) {
            gc_quest_toast("Fornalha terminou o processamento", 100);
        }

        tocar_som_efeito(snd_blip_2, 1, 1.2);
    }
}
else if (!fornalha_state.active) {
    sprite_index = spr_fornalha_fechada;
}


// =====================================================
// SEM PLAYER
// =====================================================

if (!instance_exists(obj_sdash)) {
    if (ui_open) {
        ui_open = false;

        if (variable_global_exists("game_state") && is_struct(global.game_state)) {
            if (variable_struct_exists(global.game_state.runtime, "modal_ui")
            && global.game_state.runtime.modal_ui == "fornalha") {
                global.game_state.runtime.modal_ui = "";
            }

            global.game_state.runtime.pause = false;
        }

        global.pause = false;
    }

    exit;
}

var _player = instance_find(obj_sdash, 0);
var _dist = point_distance(x, y, _player.x, _player.y);


// =====================================================
// INTERFACE ABERTA
// =====================================================

if (ui_open) {
    global.pause = true;

    if (variable_global_exists("game_state") && is_struct(global.game_state)) {
        global.game_state.runtime.pause = true;
        global.game_state.runtime.modal_ui = "fornalha";
    }

    var _recipes = receitas_fornalha;
    var _count = array_length(_recipes);

    var _move =
        keyboard_check_pressed(ord("S"))
        + keyboard_check_pressed(vk_down)
        - keyboard_check_pressed(ord("W"))
        - keyboard_check_pressed(vk_up);

    if (_move != 0) {
        ui_selected = clamp(ui_selected + sign(_move), 0, _count - 1);
        tocar_som_efeito(snd_blip_select, 1, 1);
    }

    // Layout compartilhado com o Draw GUI para mouse.
    var _gw = display_get_gui_width();
    var _gh = display_get_gui_height();

    var _panel_w = min(880, _gw - 50);
    var _panel_h = min(590, _gh - 50);

    var _px = (_gw - _panel_w) * 0.5;
    var _py = (_gh - _panel_h) * 0.5;

    var _mouse_x = device_mouse_x_to_gui(0);
    var _mouse_y = device_mouse_y_to_gui(0);

    var _list_x1 = _px + 26;
    var _list_x2 = _px + 350;
    var _list_y = _py + 116;
    var _card_h = 68;
    var _card_gap = 78;

    for (var _ri = 0; _ri < _count; _ri++) {
        var _card_y = _list_y + _ri * _card_gap;

        if (point_in_rectangle(
            _mouse_x,
            _mouse_y,
            _list_x1,
            _card_y,
            _list_x2,
            _card_y + _card_h
        )) {
            ui_selected = _ri;
        }
    }

    var _smelt_x1 = _px + _panel_w - 230;
    var _smelt_y1 = _py + _panel_h - 83;
    var _smelt_x2 = _px + _panel_w - 35;
    var _smelt_y2 = _py + _panel_h - 39;

    var _collect_x1 = _px + 385;
    var _collect_y1 = _py + _panel_h - 83;
    var _collect_x2 = _collect_x1 + 180;
    var _collect_y2 = _py + _panel_h - 39;

    var _close_x1 = _px + _panel_w - 52;
    var _close_y1 = _py + 14;
    var _close_x2 = _px + _panel_w - 18;
    var _close_y2 = _py + 46;

    var _confirm_smelt =
        keyboard_check_pressed(vk_enter)
        || gamepad_button_check_pressed(global.controle, gp_face1);

    var _collect =
        keyboard_check_pressed(vk_space);

    var _close =
        keyboard_check_pressed(vk_escape);

    if (mouse_check_button_pressed(mb_left)) {
        if (point_in_rectangle(
            _mouse_x,
            _mouse_y,
            _smelt_x1,
            _smelt_y1,
            _smelt_x2,
            _smelt_y2
        )) {
            _confirm_smelt = true;
        }

        if (point_in_rectangle(
            _mouse_x,
            _mouse_y,
            _collect_x1,
            _collect_y1,
            _collect_x2,
            _collect_y2
        )) {
            _collect = true;
        }

        if (point_in_rectangle(
            _mouse_x,
            _mouse_y,
            _close_x1,
            _close_y1,
            _close_x2,
            _close_y2
        )) {
            _close = true;
        }
    }

    // F fecha somente depois do frame de abertura.
    if (ui_open_lock <= 0
    && (keyboard_check_pressed(ord("F"))
        || gamepad_button_check_pressed(global.controle, gp_face2))) {
        _close = true;
    }


    // -------------------------------------------------
    // INICIAR RECEITA
    // -------------------------------------------------

    if (_confirm_smelt) {
        var _recipe = _recipes[ui_selected];

        if (fornalha_state.active) {
            ui_message = "A fornalha ja esta trabalhando.";
            ui_message_timer = 120;
        }
        else if (fornalha_state.output_qty > 0
        && fornalha_state.output_id != _recipe.resultado) {
            ui_message = "Colete a saida atual antes de trocar a receita.";
            ui_message_timer = 150;
        }
        else {
            var _can_start = true;
            var _wood_needed = _recipe.combustivel;

            for (var _ii = 0; _ii < array_length(_recipe.ingredientes); _ii++) {
                var _ing_check = _recipe.ingredientes[_ii];

                if (_ing_check.id == ITENS.madeira) {
                    _wood_needed += _ing_check.qtd;
                }
                else if (procura_item_inventario(_ing_check.id) < _ing_check.qtd) {
                    _can_start = false;
                }
            }

            if (procura_item_inventario(ITENS.madeira) < _wood_needed) {
                _can_start = false;
            }

            if (!_can_start) {
                ui_message = "Faltam ingredientes ou madeira.";
                ui_message_timer = 140;
                tocar_som_efeito(snd_blim, 1, 0.9);
            }
            else {
                for (var _ii = 0; _ii < array_length(_recipe.ingredientes); _ii++) {
                    var _ing_remove = _recipe.ingredientes[_ii];
                    remove_do_inventario(_ing_remove.id, _ing_remove.qtd);
                }

                remove_do_inventario(ITENS.madeira, _recipe.combustivel);

                fornalha_state.active = true;
                fornalha_state.recipe_id = ui_selected;
                fornalha_state.progress = 0;
                fornalha_state.duration = _recipe.duracao;

                if (fornalha_state.output_id == -1) {
                    fornalha_state.output_id = _recipe.resultado;
                }

                ui_message = "Fornalha acesa: " + _recipe.nome;
                ui_message_timer = 150;

                tocar_som_efeito(snd_blip_2, 1, 1);
            }
        }
    }


    // -------------------------------------------------
    // COLETAR SAIDA
    // -------------------------------------------------

    if (_collect) {
        if (fornalha_state.output_qty <= 0 || fornalha_state.output_id < 0) {
            ui_message = "Ainda nao ha nada pronto para coletar.";
            ui_message_timer = 110;
        }
        else if (adiciona_ao_inventario(
            fornalha_state.output_id,
            fornalha_state.output_qty
        )) {
            var _qty = fornalha_state.output_qty;
            var _out_item = global.itens[| fornalha_state.output_id];

            fornalha_state.output_id = -1;
            fornalha_state.output_qty = 0;

            ui_message = "Coletado: " + _out_item.nome + " x" + string(_qty);
            ui_message_timer = 140;

            tocar_som_efeito(snd_blip_2, 1, 1.1);
        }
        else {
            ui_message = "Inventario cheio.";
            ui_message_timer = 120;
        }
    }


    // -------------------------------------------------
    // FECHAR
    // -------------------------------------------------

    if (_close) {
        ui_open = false;
        global.pause = false;

        if (variable_global_exists("game_state") && is_struct(global.game_state)) {
            global.game_state.runtime.pause = false;

            if (variable_struct_exists(global.game_state.runtime, "modal_ui")
            && global.game_state.runtime.modal_ui == "fornalha") {
                global.game_state.runtime.modal_ui = "";
            }
        }

        tocar_som_efeito(snd_blip_select, 1, 0.95);
    }

    exit;
}


// =====================================================
// ABRIR INTERFACE
// =====================================================

if (_dist <= 58
&& !global.pause
&& !global.dialogo_acontecendo
&& (keyboard_check_pressed(ord("F"))
    || gamepad_button_check_pressed(global.controle, gp_face2))) {

    ui_open = true;
    ui_open_lock = 2;
    ui_selected = clamp(ui_selected, 0, array_length(receitas_fornalha) - 1);

    global.pause = true;

    if (variable_global_exists("game_state") && is_struct(global.game_state)) {
        global.game_state.runtime.pause = true;
        global.game_state.runtime.modal_ui = "fornalha";
    }

    tocar_som_efeito(snd_blip_2, 1, 1);
}

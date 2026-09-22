gc_game_state_bootstrap();

global.pause = true;
global.game_state.runtime.pause = true;
global.game_state.runtime.dev_mode = true;
global.game_state.runtime.modal_ui = "dev_console";

// F9 fecha o DEV Console.
if (keyboard_check_pressed(vk_f9) && !console_typing) {
    instance_destroy();
    exit;
}

// Console em modo de digitacao.
if (console_typing) {
    console_buffer = keyboard_string;

    if (keyboard_check_pressed(vk_escape)) {
        console_typing = false;
        keyboard_string = "";
        console_buffer = "";
    }
    else if (keyboard_check_pressed(vk_enter)) {
        var _cmd = keyboard_string;

        console_typing = false;
        keyboard_string = "";
        console_buffer = "";

        dev_exec_command(_cmd);
    }

    exit;
}

var _gw = display_get_gui_width();
var _gh = display_get_gui_height();
var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);

var _tab_x = 18;
var _tab_y = 56;
var _tab_gap = 4;
var _tab_w = max(92, floor((_gw - 36 - _tab_gap * (array_length(tab_names) - 1)) / array_length(tab_names)));
var _tab_h = 34;

// Mouse nas abas.
for (var _ti = 0; _ti < array_length(tab_names); _ti++) {
    var _x1 = _tab_x + _ti * (_tab_w + _tab_gap);

    if (point_in_rectangle(
        _mx,
        _my,
        _x1,
        _tab_y,
        _x1 + _tab_w,
        _tab_y + _tab_h
    )) {
        if (mouse_check_button_pressed(mb_left)) {
            tab = _ti;
            row = 0;
        }
    }
}

// TAB troca aba.
if (keyboard_check_pressed(vk_tab)) {
    var _dir_tab = keyboard_check(vk_shift) ? -1 : 1;

    tab = (tab + _dir_tab + array_length(tab_names)) mod array_length(tab_names);
    row = 0;
}

var _up = keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W"));
var _down = keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S"));
var _left = keyboard_check_pressed(vk_left) || keyboard_check_pressed(ord("A"));
var _right = keyboard_check_pressed(vk_right) || keyboard_check_pressed(ord("D"));
var _enter = keyboard_check_pressed(vk_enter);

// =====================================================
// RESUMO
// =====================================================
if (tab == 0) {
    var _max_rows = 6;

    if (_up) row = max(0, row - 1);
    if (_down) row = min(_max_rows - 1, row + 1);

    if (_enter) {
        switch (row) {
            case 0:
                global.moedas += 100;
                gc_game_state_sync_from_legacy();
                dev_log_push("+100 moedas.");
            break;

            case 1:
                if (instance_exists(obj_sdash)) {
                    var _p = instance_find(obj_sdash, 0);
                    _p.vida = _p.max_vida;
                    _p.estamina = _p.max_estamina;
                    dev_log_push("Sdash restaurado.");
                }
            break;

            case 2:
                adiciona_ao_inventario(ITENS.madeira, 32);
                adiciona_ao_inventario(ITENS.pedra, 32);
                adiciona_ao_inventario(ITENS.flor, 12);
                adiciona_ao_inventario(ITENS.reia, 8);
                dev_log_push("Materiais adicionados.");
            break;

            case 3:
                var _q = gc_quest_get_tracked();

                if (_q != noone) {
                    if (is_array(_q.objetivos)) {
                        for (var _i = 0; _i < array_length(_q.objetivos); _i++) {
                            _q.objetivos[_i].current = _q.objetivos[_i].required;
                            _q.objetivos[_i].complete = true;
                        }
                    }

                    _q.status = "pronta";
                    gc_quest_complete(_q.id_m);
                    dev_log_push("Missao rastreada concluida.");
                }
            break;

            case 4:
                global.game_state.runtime.debug_open = !global.game_state.runtime.debug_open;
            break;

            case 5:
                if (variable_global_exists("salva_jogo")) {
                    global.salva_jogo(save_slot_dev);
                    dev_log_push("Save executado.");
                }
            break;
        }
    }
}

// =====================================================
// PLAYER
// =====================================================
if (tab == 1) {
    row = clamp(row + _down - _up, 0, 8);

    if (instance_exists(obj_sdash)) {
        var _p = instance_find(obj_sdash, 0);
        var _delta = _right - _left;

        if (_delta != 0) {
            switch (row) {
                case 0: _p.vida = clamp(_p.vida + _delta, 0, _p.max_vida); break;
                case 1: _p.max_vida = max(1, _p.max_vida + _delta); break;
                case 2: _p.estamina = clamp(_p.estamina + _delta * 5, 0, _p.max_estamina); break;
                case 3: _p.max_estamina = max(1, _p.max_estamina + _delta * 5); break;
                case 4: _p.dano = max(0, _p.dano + _delta); break;
                case 5: _p.x = clamp(_p.x + _delta * 16, 0, room_width); break;
                case 6: _p.y = clamp(_p.y + _delta * 16, 0, room_height); break;
                case 7:
                    if (variable_instance_exists(_p, "vel_normal")) {
                        _p.vel_normal = max(0, _p.vel_normal + _delta * 0.25);
                    }
                break;
            }
        }

        if (_enter) {
            if (row == 0) _p.vida = _p.max_vida;
            if (row == 2) _p.estamina = _p.max_estamina;
            if (row == 8) _p.active = !_p.active;
        }
    }
}

// =====================================================
// CAMPANHA
// =====================================================
if (tab == 2) {
    row = clamp(row + _down - _up, 0, 12);

    var _delta = _right - _left;

    if (_delta != 0) {
        switch (row) {
            case 0:
                global.game_state.campaign.chapter = max(
                    1,
                    global.game_state.campaign.chapter + _delta
                );
            break;

            case 1:
                global.moedas = max(0, global.moedas + _delta * 10);
                gc_game_state_sync_from_legacy();
            break;

            case 2:
                global.inimigos_mortos = max(0, global.inimigos_mortos + _delta);
                gc_game_state_sync_from_legacy();
            break;

            case 3:
                global.cabalos_alimentados = max(0, global.cabalos_alimentados + _delta);
                gc_game_state_sync_from_legacy();
            break;

            case 4:
                global.orbs = max(0, global.orbs + _delta);
                gc_game_state_sync_from_legacy();
            break;

            case 5:
                global.tutorial = !global.tutorial;
                global.game_state.campaign.unlocks.tutorial = global.tutorial;
            break;

            default:
                if (row >= 6 && row <= 11) {
                    var _area = row - 5;
                    var _current = global.game_state.campaign.areas[_area - 1];
                    gc_state_area_set(_area, !_current);
                }
                else if (row == 12) {
                    var _stage_index = 0;

                    for (var _si = 0; _si < array_length(stage_names); _si++) {
                        if (stage_names[_si] == global.game_state.campaign.stage) {
                            _stage_index = _si;
                            break;
                        }
                    }

                    _stage_index = (
                        _stage_index
                        + _delta
                        + array_length(stage_names)
                    ) mod array_length(stage_names);

                    global.game_state.campaign.stage = stage_names[_stage_index];
                }
            break;
        }
    }

    if (_enter) {
        if (row == 5) {
            global.tutorial = !global.tutorial;
            global.game_state.campaign.unlocks.tutorial = global.tutorial;
        }

        if (row >= 6 && row <= 11) {
            var _area = row - 5;
            gc_state_area_set(
                _area,
                !global.game_state.campaign.areas[_area - 1]
            );
        }
    }
}

// =====================================================
// MISSOES
// =====================================================
if (tab == 3) {
    var _count = is_array(global.missoes) ? array_length(global.missoes) : 0;

    if (_count > 0) {
        quest_index = clamp(quest_index + _down - _up, 0, _count - 1);

        var _q = global.missoes[quest_index];

        if (is_array(_q.objetivos) && array_length(_q.objetivos) > 0) {
            quest_objective_index = clamp(
                quest_objective_index + _right - _left,
                0,
                array_length(_q.objetivos) - 1
            );

            var _o = _q.objetivos[quest_objective_index];

            if (keyboard_check_pressed(ord("Q"))) {
                _o.current = max(0, _o.current - 1);
                _o.complete = (_o.current >= _o.required);
            }

            if (keyboard_check_pressed(ord("E"))) {
                _o.current = min(_o.required, _o.current + 1);
                _o.complete = (_o.current >= _o.required);
            }
        }
        else {
            quest_objective_index = 0;
        }

        if (keyboard_check_pressed(ord("A"))) {
            _q.status = "ativa";
            gc_quest_track(_q.id_m);
        }

        if (keyboard_check_pressed(ord("C"))) {
            if (is_array(_q.objetivos)) {
                for (var _oi = 0; _oi < array_length(_q.objetivos); _oi++) {
                    _q.objetivos[_oi].current = _q.objetivos[_oi].required;
                    _q.objetivos[_oi].complete = true;
                }
            }

            _q.status = "pronta";
            gc_quest_complete(_q.id_m);
        }

        if (keyboard_check_pressed(ord("R"))) {
            _q.status = "bloqueada";

            if (is_array(_q.objetivos)) {
                for (var _oi = 0; _oi < array_length(_q.objetivos); _oi++) {
                    _q.objetivos[_oi].current = 0;
                    _q.objetivos[_oi].complete = false;
                }
            }
        }

        if (_enter && (_q.status == "ativa" || _q.status == "pronta")) {
            gc_quest_track(_q.id_m);
        }
    }
}

// =====================================================
// INVENTARIO
// =====================================================
if (tab == 4) {
    var _count = variable_global_exists("itens") && ds_exists(global.itens, ds_type_list)
        ? ds_list_size(global.itens)
        : 0;

    if (_count > 0) {
        item_index = clamp(item_index + _down - _up, 0, _count - 1);

        if (_enter || keyboard_check_pressed(ord("E"))) {
            adiciona_ao_inventario(item_index, keyboard_check(vk_shift) ? 10 : 1);
        }

        if (keyboard_check_pressed(ord("Q"))) {
            remove_do_inventario(item_index, keyboard_check(vk_shift) ? 10 : 1);
        }

        if (keyboard_check_pressed(ord("C"))
        && variable_global_exists("inventario_slots")
        && ds_exists(global.inventario_slots, ds_type_grid)) {
            ds_grid_clear(global.inventario_slots, noone);
        }
    }
}

// =====================================================
// ESTADO
// =====================================================
if (tab == 5) {
    if (keyboard_check_pressed(ord("Q"))) {
        state_mode = (state_mode - 1 + 3) mod 3;
        state_index = 0;
    }

    if (keyboard_check_pressed(ord("E"))) {
        state_mode = (state_mode + 1) mod 3;
        state_index = 0;
    }

    if (state_mode == 0) {
        var _flags = variable_struct_get_names(global.game_state.campaign.flags);
        var _count = array_length(_flags);

        if (_count > 0) {
            state_index = clamp(state_index + _down - _up, 0, _count - 1);

            if (_enter) {
                var _name = _flags[state_index];
                var _value = variable_struct_get(global.game_state.campaign.flags, _name);

                variable_struct_set(
                    global.game_state.campaign.flags,
                    _name,
                    !_value
                );
            }
        }
    }
    else if (state_mode == 1) {
        state_index = clamp(
            state_index + _down - _up,
            0,
            array_length(rep_names) - 1
        );

        var _delta = _right - _left;

        if (_delta != 0) {
            var _name = rep_names[state_index];
            var _current = 0;

            if (variable_struct_exists(global.game_state.campaign.reputation, _name)) {
                _current = variable_struct_get(
                    global.game_state.campaign.reputation,
                    _name
                );
            }

            variable_struct_set(
                global.game_state.campaign.reputation,
                _name,
                _current + _delta
            );

            variable_global_set(_name, _current + _delta);
        }
    }
    else {
        state_index = clamp(state_index + _down - _up, 0, 5);

        if (_enter || _left || _right) {
            gc_state_area_set(
                state_index + 1,
                !global.game_state.campaign.areas[state_index]
            );
        }
    }
}

// =====================================================
// MUNDO
// =====================================================
if (tab == 6) {
    if (keyboard_check_pressed(ord("Q"))) {
        world_mode = (world_mode - 1 + 2) mod 2;
        world_index = 0;
    }

    if (keyboard_check_pressed(ord("E"))) {
        world_mode = (world_mode + 1) mod 2;
        world_index = 0;
    }

    if (world_mode == 0) {
        world_index = clamp(
            world_index + _down - _up,
            0,
            array_length(room_names) - 1
        );

        if (_enter) {
            var _room = asset_get_index(room_names[world_index]);

            if (_room != -1) {
                room_goto(_room);
            }
        }
    }
    else {
        world_index = clamp(
            world_index + _down - _up,
            0,
            array_length(spawn_names) - 1
        );

        if (_enter) {
            var _asset = asset_get_index(spawn_names[world_index]);

            if (_asset != -1) {
                var _sx = room_width * 0.5;
                var _sy = room_height * 0.5;

                if (instance_exists(obj_sdash)) {
                    var _p = instance_find(obj_sdash, 0);
                    _sx = _p.x;
                    _sy = _p.y;
                }

                instance_create_depth(_sx + 24, _sy, -_sy, _asset);
            }
        }

        if (keyboard_check_pressed(vk_delete)) {
            var _asset = asset_get_index(spawn_names[world_index]);

            if (_asset != -1) {
                with (_asset) instance_destroy();
            }
        }
    }
}

// =====================================================
// SAVES
// =====================================================
if (tab == 7) {
    if (_left) save_slot_dev = max(1, save_slot_dev - 1);
    if (_right) save_slot_dev = min(3, save_slot_dev + 1);

    save_action = clamp(save_action + _down - _up, 0, 3);

    if (_enter) {
        switch (save_action) {
            case 0:
                if (variable_global_exists("salva_jogo")) {
                    global.salva_jogo(save_slot_dev);
                    dev_log_push("Slot " + string(save_slot_dev) + " salvo.");
                }
            break;

            case 1:
                if (variable_global_exists("carrega_jogo")) {
                    global.carrega_jogo(save_slot_dev);
                }
            break;

            case 2:
                if (variable_global_exists("delete_save_slot")) {
                    global.delete_save_slot(save_slot_dev);
                    dev_log_push("Slot " + string(save_slot_dev) + " apagado.");
                }
            break;

            case 3:
                if (variable_global_exists("novo_jogo")) {
                    global.novo_jogo(save_slot_dev);
                }
            break;
        }
    }
}

// =====================================================
// CONSOLE
// =====================================================
if (tab == 8 && _enter) {
    console_typing = true;
    keyboard_string = "";
    console_buffer = "";
}

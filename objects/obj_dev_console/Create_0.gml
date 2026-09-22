/// Dev Console interativo do Geocraft.
/// F9 abre pelo obj_misson_manager. Aqui o jogo fica congelado enquanto editamos estado.

if (instance_number(obj_dev_console) > 1) {
    instance_destroy();
    exit;
}

open_lock = 2;
tab = 0;
selected = 0;
scroll = 0;
visible_rows = 11;

tabs = [
    "JOGADOR",
    "INVENTARIO",
    "MISSOES",
    "CAMPANHA",
    "MUNDO",
    "SAVES",
    "VARS"
];

stage_values = [
    "inicio",
    "m2_cavalos",
    "m3_viagem",
    "m4_cidadaos",
    "m5_exploracao",
    "pos_m5"
];

rep_names = [
    "maldade", "bondade", "honestidade", "egoismo",
    "fama", "temido", "respeito", "caridade",
    "lealdade", "rancor", "caos", "ordem",
    "riqueza", "arrogancia", "empatia", "ambicao"
];

known_flags = [
    "almudeao_informado",
    "reconstrucao_iniciada",
    "magia_agua_descoberta",
    "andrius_derrotado"
];

known_counters = [
    "missoes_concluidas",
    "construcoes_feitas",
    "itens_fundidos"
];

// Lista explicita para evitar depender de API de enumeracao de assets em runtime.
room_list = [
    Room1, Room2, Room3, Room4_secret, Room5, Room6,
    Room7_cutscene, Room_intro, Room_skill_tree, Room_skill_tree_pag_2,
    Room_menu_pause, rm_casa1, rm_creditos, Room_shop1,
    Room_sala1_pref, room_menu_mundos, Room_quarto_sdash,
    Room_intermediario, Room_pc, Room_batalha_padrao,
    Room_dentro_masmorra, Room_dentro_masmorra_2,
    Room_game_over, room_menu, Room_logo
];

raw_vars = [
    "moedas",
    "inimigos_mortos",
    "cabalos_alimentados",
    "orbs",
    "minions_mortos",
    "tutorial",
    "modo_construcao",
    "seletor_visivel",
    "dificuldade",
    "volume_mestre",
    "lingua"
];

global.pause = true;

gc_game_state_bootstrap();

global.game_state.runtime.pause = true;
global.game_state.runtime.dev_mode = true;
global.game_state.runtime.modal_ui = "dev_console";


// =====================================================
// HELPERS
// =====================================================

dev_close = function() {
    global.pause = false;

    if (variable_global_exists("game_state") && is_struct(global.game_state)) {
        global.game_state.runtime.pause = false;
        global.game_state.runtime.dev_mode = false;

        if (variable_struct_exists(global.game_state.runtime, "modal_ui")
        && global.game_state.runtime.modal_ui == "dev_console") {
            global.game_state.runtime.modal_ui = "";
        }

        global.game_state.runtime.interaction_lock = 3;
    }

    instance_destroy();
};


dev_array_has = function(_arr, _value) {
    for (var _i = 0; _i < array_length(_arr); _i++) {
        if (string(_arr[_i]) == string(_value)) return true;
    }

    return false;
};


dev_flags = function() {
    var _out = [];

    for (var _i = 0; _i < array_length(known_flags); _i++) {
        array_push(_out, known_flags[_i]);
    }

    var _dynamic = variable_struct_get_names(global.game_state.campaign.flags);

    for (var _i = 0; _i < array_length(_dynamic); _i++) {
        if (!dev_array_has(_out, _dynamic[_i])) {
            array_push(_out, _dynamic[_i]);
        }
    }

    // Flags de quest ja conhecidas.
    if (variable_global_exists("missoes") && is_array(global.missoes)) {
        for (var _q = 0; _q < array_length(global.missoes); _q++) {
            var _mission = global.missoes[_q];

            if (is_struct(_mission) && variable_struct_exists(_mission, "id_m")) {
                var _flag = "quest_" + string(_mission.id_m) + "_concluida";

                if (!dev_array_has(_out, _flag)) {
                    array_push(_out, _flag);
                }
            }
        }
    }

    return _out;
};


dev_counters = function() {
    var _out = [];

    for (var _i = 0; _i < array_length(known_counters); _i++) {
        array_push(_out, known_counters[_i]);
    }

    var _dynamic = variable_struct_get_names(global.game_state.campaign.counters);

    for (var _i = 0; _i < array_length(_dynamic); _i++) {
        if (!dev_array_has(_out, _dynamic[_i])) {
            array_push(_out, _dynamic[_i]);
        }
    }

    return _out;
};


dev_item_count = function(_item_id) {
    if (!variable_global_exists("inventario_slots")) return 0;
    if (!ds_exists(global.inventario_slots, ds_type_grid)) return 0;

    return procura_item_inventario(_item_id);
};


dev_item_set = function(_item_id, _amount) {
    if (!variable_global_exists("inventario_slots")) return false;
    if (!ds_exists(global.inventario_slots, ds_type_grid)) return false;

    _amount = max(0, floor(_amount));

    var _current = dev_item_count(_item_id);

    if (_current > _amount) {
        return remove_do_inventario(_item_id, _current - _amount);
    }

    if (_current < _amount) {
        return adiciona_ao_inventario(_item_id, _amount - _current);
    }

    return true;
};


dev_quest_status_index = function(_status) {
    var _statuses = ["bloqueada", "ativa", "pronta", "concluida"];

    for (var _i = 0; _i < array_length(_statuses); _i++) {
        if (_statuses[_i] == _status) return _i;
    }

    return 0;
};


dev_row_count = function() {
    switch (tab) {
        case 0: // jogador
            return 12;

        case 1: // inventario
            if (variable_global_exists("itens")
            && ds_exists(global.itens, ds_type_list)) {
                return ds_list_size(global.itens);
            }
            return 0;

        case 2: // missoes
            return variable_global_exists("missoes") && is_array(global.missoes)
                ? array_length(global.missoes)
                : 0;

        case 3: // campanha
            return 2
                + 6
                + array_length(rep_names)
                + array_length(dev_flags())
                + array_length(dev_counters())
                + 5;

        case 4: // mundo
            return array_length(room_list) + 6;

        case 5: // saves
            return 13;

        case 6: // globals selecionados
            return array_length(raw_vars);
    }

    return 0;
};


dev_stage_index = function() {
    var _stage = string(global.game_state.campaign.stage);

    for (var _i = 0; _i < array_length(stage_values); _i++) {
        if (stage_values[_i] == _stage) return _i;
    }

    return 0;
};


// =====================================================
// ALTERAR VALOR
// _dir: -1 ou +1
// _confirm: acao principal / toggle
// =====================================================

dev_edit = function(_dir, _confirm = false) {
    var _step = keyboard_check(vk_shift) ? 10 : 1;

    switch (tab) {
        // -------------------------------------------------
        // JOGADOR
        // -------------------------------------------------
        case 0:
            if (!instance_exists(obj_sdash)) return;
            var _p = instance_find(obj_sdash, 0);

            switch (selected) {
                case 0:
                    if (_dir != 0) _p.vida = clamp(_p.vida + _dir * _step, 0, _p.max_vida);
                break;

                case 1:
                    if (_dir != 0) {
                        _p.max_vida = max(1, _p.max_vida + _dir * _step);
                        _p.vida = min(_p.vida, _p.max_vida);
                    }
                break;

                case 2:
                    if (_dir != 0) _p.estamina = clamp(_p.estamina + _dir * _step, 0, _p.max_estamina);
                break;

                case 3:
                    if (_dir != 0) {
                        _p.max_estamina = max(1, _p.max_estamina + _dir * _step);
                        _p.estamina = min(_p.estamina, _p.max_estamina);
                    }
                break;

                case 4:
                    if (_dir != 0) _p.dano = max(0, _p.dano + _dir * _step);
                break;

                case 5:
                    if (_dir != 0) _p.veloc = max(0.25, _p.veloc + _dir * 0.25 * _step);
                break;

                case 6:
                    if (_dir != 0) _p.dash_veloc = max(0.5, _p.dash_veloc + _dir * 0.5 * _step);
                break;

                case 7:
                    if (_dir != 0) _p.x = clamp(_p.x + _dir * 16 * _step, 0, room_width);
                break;

                case 8:
                    if (_dir != 0) _p.y = clamp(_p.y + _dir * 16 * _step, 0, room_height);
                break;

                case 9:
                    if (_dir != 0) {
                        global.moedas = max(0, global.moedas + _dir * 10 * _step);
                        gc_game_state_sync_from_legacy();
                    }
                break;

                case 10:
                    if (_confirm) {
                        _p.vida = _p.max_vida;
                        _p.estamina = _p.max_estamina;
                    }
                break;

                case 11:
                    if (_confirm || _dir != 0) {
                        _p.tomardano = !_p.tomardano;
                    }
                break;
            }
        break;


        // -------------------------------------------------
        // INVENTARIO
        // -------------------------------------------------
        case 1:
            if (!variable_global_exists("itens")
            || !ds_exists(global.itens, ds_type_list)) return;

            if (selected < 0 || selected >= ds_list_size(global.itens)) return;

            var _item = global.itens[| selected];
            if (!is_struct(_item)) return;

            var _current = dev_item_count(selected);

            if (_confirm) {
                var _target = (_current > 0) ? 0 : max(1, _item.max_stack);
                dev_item_set(selected, _target);
            }
            else if (_dir != 0) {
                dev_item_set(selected, max(0, _current + _dir * _step));
            }
        break;


        // -------------------------------------------------
        // MISSOES
        // -------------------------------------------------
        case 2:
            if (!variable_global_exists("missoes") || !is_array(global.missoes)) return;
            if (selected < 0 || selected >= array_length(global.missoes)) return;

            var _q = global.missoes[selected];
            if (!is_struct(_q)) return;

            if (_dir != 0) {
                var _statuses = ["bloqueada", "ativa", "pronta", "concluida"];
                var _si = dev_quest_status_index(_q.status);
                _si = clamp(_si + _dir, 0, array_length(_statuses) - 1);
                _q.status = _statuses[_si];

                if (_q.status == "concluida"
                && variable_struct_exists(_q, "objetivos")
                && is_array(_q.objetivos)) {
                    for (var _oi = 0; _oi < array_length(_q.objetivos); _oi++) {
                        _q.objetivos[_oi].current = _q.objetivos[_oi].required;
                        _q.objetivos[_oi].complete = true;
                    }
                }
            }

            if (_confirm) {
                if (_q.status == "concluida") {
                    _q.status = "ativa";

                    if (variable_struct_exists(_q, "objetivos") && is_array(_q.objetivos)) {
                        for (var _oi = 0; _oi < array_length(_q.objetivos); _oi++) {
                            _q.objetivos[_oi].current = 0;
                            _q.objetivos[_oi].complete = false;
                        }
                    }
                }
                else {
                    if (variable_struct_exists(_q, "objetivos") && is_array(_q.objetivos)) {
                        for (var _oi = 0; _oi < array_length(_q.objetivos); _oi++) {
                            _q.objetivos[_oi].current = _q.objetivos[_oi].required;
                            _q.objetivos[_oi].complete = true;
                        }
                    }

                    _q.status = "concluida";
                    gc_state_flag_set("quest_" + _q.id_m + "_concluida", true);
                }
            }

            global.game_state.missions = global.missoes;
        break;


        // -------------------------------------------------
        // CAMPANHA
        // -------------------------------------------------
        case 3:
            var _flags = dev_flags();
            var _counters = dev_counters();

            if (selected == 0) {
                if (_dir != 0) {
                    global.game_state.campaign.chapter = max(
                        0,
                        global.game_state.campaign.chapter + _dir * _step
                    );
                }
                return;
            }

            if (selected == 1) {
                if (_dir != 0 || _confirm) {
                    var _stage_i = dev_stage_index();
                    _stage_i = (_stage_i + (_dir == 0 ? 1 : _dir) + array_length(stage_values)) mod array_length(stage_values);
                    global.game_state.campaign.stage = stage_values[_stage_i];
                }
                return;
            }

            var _cursor = 2;

            // Areas.
            if (selected >= _cursor && selected < _cursor + 6) {
                var _area = selected - _cursor + 1;

                if (_confirm || _dir != 0) {
                    var _current_area = global.game_state.campaign.areas[_area - 1];
                    gc_state_area_set(_area, !_current_area);
                }
                return;
            }

            _cursor += 6;

            // Reputacao.
            if (selected >= _cursor && selected < _cursor + array_length(rep_names)) {
                var _rep = rep_names[selected - _cursor];

                if (_dir != 0) {
                    gc_state_reputation_add(_rep, _dir * _step);
                }
                return;
            }

            _cursor += array_length(rep_names);

            // Flags.
            if (selected >= _cursor && selected < _cursor + array_length(_flags)) {
                var _flag = _flags[selected - _cursor];

                if (_confirm || _dir != 0) {
                    gc_state_flag_set(_flag, !gc_state_flag_get(_flag, false));
                }
                return;
            }

            _cursor += array_length(_flags);

            // Counters.
            if (selected >= _cursor && selected < _cursor + array_length(_counters)) {
                var _counter = _counters[selected - _cursor];

                if (_dir != 0) {
                    var _value = max(
                        0,
                        gc_state_counter_get(_counter, 0) + _dir * _step
                    );

                    gc_state_counter_set(_counter, _value);
                }
                return;
            }

            _cursor += array_length(_counters);

            // Magias 0..4.
            if (selected >= _cursor && selected < _cursor + 5) {
                var _magic = selected - _cursor;

                if (_confirm || _dir != 0) {
                    var _unlocked = false;

                    if (is_array(global.tem_magia)
                    && _magic < array_length(global.tem_magia)) {
                        _unlocked = global.tem_magia[_magic];
                    }

                    gc_state_magic_set(_magic, !_unlocked);
                }
            }
        break;


        // -------------------------------------------------
        // MUNDO
        // -------------------------------------------------
        case 4:
            var _room_count = array_length(room_list);

            if (selected < _room_count) {
                if (_confirm) {
                    var _target = room_list[selected];

                    // Fecha o console antes da transicao.
                    global.pause = false;
                    global.game_state.runtime.pause = false;
                    global.game_state.runtime.dev_mode = false;
                    global.game_state.runtime.modal_ui = "";

                    var _tr = instance_create_layer(0, 0, "Instances", obj_transition);
                    _tr.target_room = _target;
                    _tr.target_x = 64;
                    _tr.target_y = 64;

                    instance_destroy();
                }

                return;
            }

            var _wr = selected - _room_count;

            switch (_wr) {
                case 0:
                    if (_dir != 0) {
                        global.inimigos_mortos = max(0, global.inimigos_mortos + _dir * _step);
                        gc_game_state_sync_from_legacy();
                    }
                break;

                case 1:
                    if (_dir != 0) {
                        global.cabalos_alimentados = max(0, global.cabalos_alimentados + _dir * _step);
                        gc_game_state_sync_from_legacy();
                    }
                break;

                case 2:
                    if (_dir != 0) {
                        global.orbs = max(0, global.orbs + _dir * _step);
                        gc_game_state_sync_from_legacy();
                    }
                break;

                case 3:
                    if (_dir != 0) {
                        global.minions_mortos = max(0, global.minions_mortos + _dir * _step);
                        gc_game_state_sync_from_legacy();
                    }
                break;

                case 4:
                    if (_confirm) {
                        global.game_state.world.placed_structures = [];

                        with (obj_fornalha) {
                            instance_destroy();
                        }
                    }
                break;

                case 5:
                    if (_confirm) {
                        global.game_state.world.furnaces = [];
                    }
                break;
            }
        break;


        // -------------------------------------------------
        // SAVES
        // 0..3 slot 1, 4..7 slot 2, 8..11 slot 3, 12 reset campaign
        // -------------------------------------------------
        case 5:
            if (!_confirm) return;

            if (selected < 12) {
                var _slot = floor(selected / 4) + 1;
                var _action = selected mod 4;

                switch (_action) {
                    case 0:
                        global.salva_jogo(_slot);
                    break;

                    case 1:
                        // Load encerra o console.
                        global.pause = false;
                        global.game_state.runtime.pause = false;
                        global.game_state.runtime.dev_mode = false;
                        global.game_state.runtime.modal_ui = "";
                        instance_destroy();
                        global.carrega_jogo(_slot);
                    break;

                    case 2:
                        global.delete_save_slot(_slot);
                    break;

                    case 3:
                        global.pause = false;
                        global.game_state.runtime.pause = false;
                        global.game_state.runtime.dev_mode = false;
                        global.game_state.runtime.modal_ui = "";
                        instance_destroy();
                        global.novo_jogo(_slot);
                    break;
                }
            }
            else {
                gc_game_state_new_run();
                gc_game_state_bootstrap();
                global.pause = true;
                global.game_state.runtime.pause = true;
                global.game_state.runtime.dev_mode = true;
                global.game_state.runtime.modal_ui = "dev_console";
            }
        break;


        // -------------------------------------------------
        // VARIAVEIS GLOBAIS COMUNS
        // -------------------------------------------------
        case 6:
            if (selected < 0 || selected >= array_length(raw_vars)) return;

            var _name = raw_vars[selected];

            if (!variable_global_exists(_name)) return;

            var _value = variable_global_get(_name);

            if (is_bool(_value)) {
                if (_confirm || _dir != 0) {
                    variable_global_set(_name, !_value);
                }
            }
            else if (is_real(_value)) {
                if (_dir != 0) {
                    var _delta = _dir * _step;

                    if (_name == "volume_mestre") {
                        variable_global_set(
                            _name,
                            clamp(_value + _dir * 0.05, 0, 1)
                        );

                        audio_master_gain(global.volume_mestre);
                    }
                    else {
                        variable_global_set(_name, _value + _delta);
                    }
                }
            }
            else if (is_string(_value)) {
                if (_confirm || _dir != 0) {
                    if (_name == "lingua") {
                        variable_global_set(
                            _name,
                            (_value == "pt-br") ? "en" : "pt-br"
                        );
                    }
                }
            }

            gc_game_state_sync_from_legacy();
        break;
    }
};


// =====================================================
// LABEL / VALUE PARA UI
// =====================================================

dev_label = function(_row) {
    switch (tab) {
        case 0:
            var _labels = [
                "Vida", "Vida maxima", "Estamina", "Estamina maxima",
                "Dano base", "Velocidade", "Velocidade do dash",
                "Posicao X", "Posicao Y", "Moedas",
                "CURAR TUDO", "Receber dano"
            ];
            return _labels[_row];

        case 1:
            if (ds_exists(global.itens, ds_type_list)
            && _row < ds_list_size(global.itens)) {
                var _item = global.itens[| _row];
                return is_struct(_item) ? string(_item.nome) : ("Item " + string(_row));
            }
            return "Item " + string(_row);

        case 2:
            if (is_array(global.missoes) && _row < array_length(global.missoes)) {
                return string(global.missoes[_row].nome);
            }
            return "Missao";

        case 3:
            if (_row == 0) return "Capitulo";
            if (_row == 1) return "Etapa";

            var _flags = dev_flags();
            var _counters = dev_counters();
            var _cursor = 2;

            if (_row < _cursor + 6) {
                return "Area " + string(_row - _cursor + 1);
            }

            _cursor += 6;

            if (_row < _cursor + array_length(rep_names)) {
                return "Rep: " + rep_names[_row - _cursor];
            }

            _cursor += array_length(rep_names);

            if (_row < _cursor + array_length(_flags)) {
                return "Flag: " + _flags[_row - _cursor];
            }

            _cursor += array_length(_flags);

            if (_row < _cursor + array_length(_counters)) {
                return "Counter: " + _counters[_row - _cursor];
            }

            _cursor += array_length(_counters);

            return "Magia " + string(_row - _cursor + 1);

        case 4:
            if (_row < array_length(room_list)) {
                return "Ir para: " + room_get_name(room_list[_row]);
            }

            var _wr = _row - array_length(room_list);
            var _world_labels = [
                "Inimigos mortos",
                "Cavalos alimentados",
                "Orbs",
                "Minions mortos",
                "APAGAR CONSTRUCOES",
                "RESETAR FORNALHAS"
            ];

            return _world_labels[_wr];

        case 5:
            if (_row < 12) {
                var _slot = floor(_row / 4) + 1;
                var _action = _row mod 4;
                var _actions = ["Salvar", "Carregar", "Apagar", "Novo jogo"];
                return _actions[_action] + " - Slot " + string(_slot);
            }

            return "RESETAR CAMPANHA ATUAL";

        case 6:
            return raw_vars[_row];
    }

    return "";
};


dev_value = function(_row) {
    switch (tab) {
        case 0:
            if (!instance_exists(obj_sdash)) return "Sdash ausente";

            var _p = instance_find(obj_sdash, 0);

            switch (_row) {
                case 0: return string(_p.vida);
                case 1: return string(_p.max_vida);
                case 2: return string(round(_p.estamina));
                case 3: return string(round(_p.max_estamina));
                case 4: return string(_p.dano);
                case 5: return string(_p.veloc);
                case 6: return string(_p.dash_veloc);
                case 7: return string(round(_p.x));
                case 8: return string(round(_p.y));
                case 9: return string(global.moedas);
                case 10: return "[ENTER]";
                case 11: return _p.tomardano ? "SIM" : "NAO / GOD";
            }
        break;

        case 1:
            return string(dev_item_count(_row));

        case 2:
            if (is_array(global.missoes) && _row < array_length(global.missoes)) {
                var _q = global.missoes[_row];
                var _done = 0;
                var _total = 0;

                if (variable_struct_exists(_q, "objetivos") && is_array(_q.objetivos)) {
                    _total = array_length(_q.objetivos);

                    for (var _i = 0; _i < _total; _i++) {
                        if (_q.objetivos[_i].complete) _done++;
                    }
                }

                return string(_q.status) + "  " + string(_done) + "/" + string(_total);
            }
        break;

        case 3:
            if (_row == 0) return string(global.game_state.campaign.chapter);
            if (_row == 1) return string(global.game_state.campaign.stage);

            var _flags = dev_flags();
            var _counters = dev_counters();
            var _cursor = 2;

            if (_row < _cursor + 6) {
                var _area = _row - _cursor + 1;
                return global.game_state.campaign.areas[_area - 1]
                    ? "LIBERADA"
                    : "BLOQUEADA";
            }

            _cursor += 6;

            if (_row < _cursor + array_length(rep_names)) {
                var _rep = rep_names[_row - _cursor];

                if (!variable_struct_exists(global.game_state.campaign.reputation, _rep)) {
                    variable_struct_set(global.game_state.campaign.reputation, _rep, 0);
                }

                return string(
                    variable_struct_get(global.game_state.campaign.reputation, _rep)
                );
            }

            _cursor += array_length(rep_names);

            if (_row < _cursor + array_length(_flags)) {
                var _flag = _flags[_row - _cursor];
                return gc_state_flag_get(_flag, false) ? "TRUE" : "FALSE";
            }

            _cursor += array_length(_flags);

            if (_row < _cursor + array_length(_counters)) {
                var _counter = _counters[_row - _cursor];
                return string(gc_state_counter_get(_counter, 0));
            }

            _cursor += array_length(_counters);

            var _magic = _row - _cursor;
            return (
                is_array(global.tem_magia)
                && _magic < array_length(global.tem_magia)
                && global.tem_magia[_magic]
            ) ? "DESBLOQUEADA" : "BLOQUEADA";

        case 4:
            if (_row < array_length(room_list)) {
                return room == room_list[_row] ? "ROOM ATUAL" : "[ENTER]";
            }

            switch (_row - array_length(room_list)) {
                case 0: return string(global.inimigos_mortos);
                case 1: return string(global.cabalos_alimentados);
                case 2: return string(global.orbs);
                case 3: return string(global.minions_mortos);
                default: return "[ENTER]";
            }

        case 5:
            if (_row < 12) {
                var _slot = floor(_row / 4) + 1;
                var _action = _row mod 4;

                if (_action == 0 || _action == 1 || _action == 2) {
                    var _meta = global.save_slot_meta(_slot);

                    if (_meta.exists) {
                        return _meta.room_name + " | $" + string(_meta.moedas);
                    }

                    return "VAZIO";
                }

                return "[ENTER]";
            }

            return "[ENTER]";

        case 6:
            var _name = raw_vars[_row];

            if (!variable_global_exists(_name)) return "NAO EXISTE";

            return string(variable_global_get(_name));
    }

    return "";
};

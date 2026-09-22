/// @description Console de desenvolvimento interativo do Geocraft.
/// F9 abre/fecha. Q/E troca abas. W/S seleciona. A/D altera. ENTER executa.

function gc_dev_setup() {
    gc_game_state_bootstrap();

    if (!variable_global_exists("controle")) global.controle = -1;
    if (!variable_global_exists("save_slot")) global.save_slot = 1;
    if (!variable_global_exists("volume_mestre")) global.volume_mestre = 1;
    if (!variable_global_exists("dificuldade")) global.dificuldade = 1;
    if (!variable_global_exists("moedas")) global.moedas = 0;

    if (variable_struct_exists(global.game_state.runtime, "dev_console")
    && is_struct(global.game_state.runtime.dev_console)) {
        return global.game_state.runtime.dev_console;
    }

    global.game_state.runtime.dev_console = {
        open : false,
        tab : 0,
        row : 0,
        item_id : 0,
        item_qty : 1,
        quest_index : 0,
        objective_index : 0,
        room_index : 0,
        reputation_index : 0,
        counter_index : 0,
        area_index : 0,
        magic_index : 0,
        flag_index : 0,
        save_slot : variable_global_exists("save_slot") ? global.save_slot : 1,
        confirm_danger : "",
        message : "",
        message_timer : 0
    };

    return global.game_state.runtime.dev_console;
}

function gc_dev_tabs() {
    return [
        "PLAYER",
        "INVENTARIO",
        "CAMPANHA",
        "MISSOES",
        "MUNDO",
        "SAVE / SISTEMA"
    ];
}

function gc_dev_reputations() {
    return [
        "maldade", "bondade", "honestidade", "egoismo",
        "fama", "temido", "respeito", "caridade",
        "lealdade", "rancor", "caos", "ordem",
        "riqueza", "arrogancia", "empatia", "ambicao"
    ];
}

function gc_dev_counters() {
    return [
        "inimigos_mortos",
        "cabalos_alimentados",
        "orbs",
        "minions_mortos",
        "missoes_concluidas",
        "construcoes_feitas",
        "itens_fundidos",
        "aldeoes_despetrificados"
    ];
}

function gc_dev_flags() {
    return [
        "almudeao_informado",
        "reconstrucao_iniciada",
        "magia_agua_descoberta",
        "andrius_derrotado",
        "prefeitura_liberada",
        "aldeia_1_reconstruida",
        "tutorial_concluido",
        "primeiro_save"
    ];
}

function gc_dev_stages() {
    return [
        "inicio",
        "m2_cavalos",
        "m3_viagem",
        "m4_cidadaos",
        "m5_exploracao",
        "pos_m5"
    ];
}

function gc_dev_rooms() {
    return [
        Room1,
        Room2,
        Room3,
        Room4_secret,
        Room5,
        Room6,
        Room7_cutscene,
        rm_casa1,
        Room_shop1,
        Room_sala1_pref,
        Room_quarto_sdash,
        Room_intermediario,
        Room_pc,
        Room_batalha_padrao,
        Room_dentro_masmorra,
        Room_dentro_masmorra_2
    ];
}

function gc_dev_message(_text, _frames = 150) {
    var _dev = gc_dev_setup();
    _dev.message = string(_text);
    _dev.message_timer = _frames;
}

function gc_dev_row_count(_tab) {
    switch (_tab) {
        case 0: return 8;  // player
        case 1: return 7;  // inventario
        case 2: return 12; // campanha
        case 3: return 7;  // missoes
        case 4: return 7;  // mundo
        case 5: return 10; // save/sistema
    }

    return 1;
}

function gc_dev_get_stage_index() {
    gc_game_state_bootstrap();

    var _stages = gc_dev_stages();
    var _current = string(global.game_state.campaign.stage);

    for (var _i = 0; _i < array_length(_stages); _i++) {
        if (_stages[_i] == _current) return _i;
    }

    return 0;
}

function gc_dev_set_stage_by_index(_index) {
    var _stages = gc_dev_stages();
    _index = clamp(_index, 0, array_length(_stages) - 1);

    global.game_state.campaign.stage = _stages[_index];
    gc_dev_message("Etapa: " + _stages[_index]);
}

function gc_dev_get_flag(_name) {
    return gc_state_flag_get(_name, false);
}

function gc_dev_toggle_flag(_name) {
    var _new_value = !gc_state_flag_get(_name, false);
    gc_state_flag_set(_name, _new_value);

    gc_dev_message(
        _name + " = " + (_new_value ? "true" : "false")
    );
}

function gc_dev_clear_inventory() {
    if (!variable_global_exists("inventario_slots")) return false;
    if (!ds_exists(global.inventario_slots, ds_type_grid)) return false;

    ds_grid_clear(global.inventario_slots, 0);
    global.item_player = noone;

    gc_dev_message("Inventario limpo");
    return true;
}

function gc_dev_reset_quest(_q) {
    if (!is_struct(_q)) return false;

    _q.status = "bloqueada";

    if (variable_struct_exists(_q, "objetivos")
    && is_array(_q.objetivos)) {
        for (var _i = 0; _i < array_length(_q.objetivos); _i++) {
            _q.objetivos[_i].current = 0;
            _q.objetivos[_i].complete = false;
        }
    }

    gc_dev_message("Missao resetada: " + _q.nome);
    return true;
}

function gc_dev_cycle_quest_status(_q, _dir) {
    if (!is_struct(_q)) return;

    var _states = ["bloqueada", "ativa", "pronta", "concluida"];
    var _idx = 0;

    for (var _i = 0; _i < array_length(_states); _i++) {
        if (_states[_i] == _q.status) {
            _idx = _i;
            break;
        }
    }

    _idx = (_idx + _dir + array_length(_states)) mod array_length(_states);
    _q.status = _states[_idx];

    if (_q.status == "concluida"
    && variable_struct_exists(_q, "objetivos")
    && is_array(_q.objetivos)) {
        for (var _o = 0; _o < array_length(_q.objetivos); _o++) {
            _q.objetivos[_o].current = _q.objetivos[_o].required;
            _q.objetivos[_o].complete = true;
        }
    }

    gc_dev_message(_q.nome + ": " + _q.status);
}

function gc_dev_teleport(_room_asset) {
    if (_room_asset == -1 || _room_asset == noone) return false;

    if (!instance_exists(obj_sdash)) {
        room_goto(_room_asset);
        return true;
    }

    var _s = instance_find(obj_sdash, 0);

    if (room == _room_asset) {
        _s.x = room_width * 0.5;
        _s.y = room_height * 0.5;
    }
    else {
        var _tr = instance_create_layer(0, 0, "Instances", obj_transition);
        _tr.target_room = _room_asset;
        _tr.target_x = 64;
        _tr.target_y = 64;
    }

    gc_dev_close();
    return true;
}

function gc_dev_open() {
    var _dev = gc_dev_setup();

    if (_dev.open) return;

    // O console DEV vira a unica UI modal ativa.
    if (variable_struct_exists(global.game_state.runtime, "quest_journal_open")) {
        global.game_state.runtime.quest_journal_open = false;
    }

    if (variable_global_exists("pause_menu") && is_struct(global.pause_menu)) {
        global.pause_menu.active = false;
    }

    if (instance_exists(obj_inventario)) {
        var _inv = instance_find(obj_inventario, 0);
        if (variable_instance_exists(_inv, "inventario")) {
            _inv.inventario = false;
        }
    }

    global.pause_por_inventario = false;

    _dev.open = true;
    _dev.row = 0;
    _dev.confirm_danger = "";

    global.game_state.runtime.dev_mode = true;
    global.game_state.runtime.modal_ui = "dev_console";
    global.game_state.runtime.pause = true;
    global.pause = true;

    gc_dev_message("DEV CONSOLE aberto");
}

function gc_dev_close() {
    var _dev = gc_dev_setup();

    _dev.open = false;
    _dev.confirm_danger = "";

    global.game_state.runtime.dev_mode = false;

    if (global.game_state.runtime.modal_ui == "dev_console") {
        global.game_state.runtime.modal_ui = "";
    }

    global.game_state.runtime.pause = false;
    global.pause = false;
}

function gc_dev_toggle() {
    var _dev = gc_dev_setup();

    if (_dev.open) gc_dev_close();
    else gc_dev_open();
}

function gc_dev_apply_delta(_manager, _delta) {
    var _dev = gc_dev_setup();
    var _tab = _dev.tab;
    var _row = _dev.row;

    if (_delta == 0) return;

    switch (_tab) {
        // =================================================
        // PLAYER
        // =================================================
        case 0:
            if (!instance_exists(obj_sdash)) return;

            var _s = instance_find(obj_sdash, 0);

            switch (_row) {
                case 0: _s.vida = clamp(_s.vida + _delta, 0, _s.max_vida); break;
                case 1:
                    _s.max_vida = max(1, _s.max_vida + _delta);
                    _s.vida = min(_s.vida, _s.max_vida);
                break;

                case 2: _s.estamina = clamp(_s.estamina + _delta * 5, 0, _s.max_estamina); break;
                case 3:
                    _s.max_estamina = max(1, _s.max_estamina + _delta * 5);
                    _s.estamina = min(_s.estamina, _s.max_estamina);
                break;

                case 4: _s.x = clamp(_s.x + _delta * 16, 0, room_width); break;
                case 5: _s.y = clamp(_s.y + _delta * 16, 0, room_height); break;
            }
        break;

        // =================================================
        // INVENTARIO
        // =================================================
        case 1:
            switch (_row) {
                case 0:
                    if (variable_global_exists("itens")
                    && ds_exists(global.itens, ds_type_list)) {
                        _dev.item_id = clamp(
                            _dev.item_id + _delta,
                            0,
                            max(0, ds_list_size(global.itens) - 1)
                        );
                    }
                break;

                case 1:
                    _dev.item_qty = clamp(_dev.item_qty + _delta, 1, 999);
                break;

                case 5:
                    global.moedas = max(0, global.moedas + _delta * 10);
                    gc_game_state_sync_from_legacy();
                break;
            }
        break;

        // =================================================
        // CAMPANHA
        // =================================================
        case 2:
            var _reps = gc_dev_reputations();
            var _counters = gc_dev_counters();
            var _flags = gc_dev_flags();

            switch (_row) {
                case 0:
                    global.game_state.campaign.chapter = max(
                        1,
                        global.game_state.campaign.chapter + _delta
                    );
                break;

                case 1:
                    gc_dev_set_stage_by_index(
                        clamp(
                            gc_dev_get_stage_index() + _delta,
                            0,
                            array_length(gc_dev_stages()) - 1
                        )
                    );
                break;

                case 2:
                    _dev.reputation_index = clamp(
                        _dev.reputation_index + _delta,
                        0,
                        array_length(_reps) - 1
                    );
                break;

                case 3:
                    gc_state_reputation_add(
                        _reps[_dev.reputation_index],
                        _delta
                    );
                break;

                case 4:
                    _dev.area_index = clamp(_dev.area_index + _delta, 0, 5);
                break;

                case 6:
                    _dev.magic_index = clamp(_dev.magic_index + _delta, 0, 4);
                break;

                case 8:
                    _dev.counter_index = clamp(
                        _dev.counter_index + _delta,
                        0,
                        array_length(_counters) - 1
                    );
                break;

                case 9:
                    var _counter_name = _counters[_dev.counter_index];
                    gc_state_counter_set(
                        _counter_name,
                        max(0, gc_state_counter_get(_counter_name, 0) + _delta)
                    );
                break;

                case 10:
                    _dev.flag_index = clamp(
                        _dev.flag_index + _delta,
                        0,
                        array_length(_flags) - 1
                    );
                break;
            }
        break;

        // =================================================
        // MISSOES
        // =================================================
        case 3:
            if (!variable_global_exists("missoes") || !is_array(global.missoes)) return;
            if (array_length(global.missoes) <= 0) return;

            switch (_row) {
                case 0:
                    _dev.quest_index = clamp(
                        _dev.quest_index + _delta,
                        0,
                        array_length(global.missoes) - 1
                    );
                    _dev.objective_index = 0;
                break;

                case 1:
                    gc_dev_cycle_quest_status(
                        global.missoes[_dev.quest_index],
                        _delta
                    );
                break;

                case 2:
                    var _q_obj = global.missoes[_dev.quest_index];

                    if (variable_struct_exists(_q_obj, "objetivos")
                    && is_array(_q_obj.objetivos)
                    && array_length(_q_obj.objetivos) > 0) {
                        _dev.objective_index = clamp(
                            _dev.objective_index + _delta,
                            0,
                            array_length(_q_obj.objetivos) - 1
                        );
                    }
                break;

                case 3:
                    var _q_prog = global.missoes[_dev.quest_index];

                    if (variable_struct_exists(_q_prog, "objetivos")
                    && is_array(_q_prog.objetivos)
                    && array_length(_q_prog.objetivos) > 0) {
                        var _o = _q_prog.objetivos[_dev.objective_index];
                        _o.current = clamp(_o.current + _delta, 0, _o.required);
                        _o.complete = (_o.current >= _o.required);
                    }
                break;
            }
        break;

        // =================================================
        // MUNDO
        // =================================================
        case 4:
            var _rooms = gc_dev_rooms();

            switch (_row) {
                case 0:
                    _dev.room_index = clamp(
                        _dev.room_index + _delta,
                        0,
                        array_length(_rooms) - 1
                    );
                break;

                case 2:
                    if (instance_exists(obj_sdash)) {
                        var _ws = instance_find(obj_sdash, 0);
                        _ws.x = clamp(_ws.x + _delta * 32, 0, room_width);
                    }
                break;

                case 3:
                    if (instance_exists(obj_sdash)) {
                        var _ws2 = instance_find(obj_sdash, 0);
                        _ws2.y = clamp(_ws2.y + _delta * 32, 0, room_height);
                    }
                break;
            }
        break;

        // =================================================
        // SAVE / SISTEMA
        // =================================================
        case 5:
            switch (_row) {
                case 0:
                    _dev.save_slot = clamp(_dev.save_slot + _delta, 1, 3);
                break;

                case 6:
                    global.volume_mestre = clamp(
                        global.volume_mestre + _delta * 0.05,
                        0,
                        1
                    );
                    audio_master_gain(global.volume_mestre);
                break;

                case 7:
                    global.dificuldade = clamp(global.dificuldade + _delta, 0, 2);
                break;
            }
        break;
    }
}

function gc_dev_confirm(_manager) {
    var _dev = gc_dev_setup();
    var _tab = _dev.tab;
    var _row = _dev.row;

    switch (_tab) {
        case 0:
            if (!instance_exists(obj_sdash)) return;
            var _s = instance_find(obj_sdash, 0);

            switch (_row) {
                case 6:
                    _s.vida = _s.max_vida;
                    _s.estamina = _s.max_estamina;
                    gc_dev_message("Player restaurado");
                break;

                case 7:
                    _s.vida = 1;
                    gc_dev_message("Vida = 1");
                break;
            }
        break;

        case 1:
            if (!variable_global_exists("itens")
            || !ds_exists(global.itens, ds_type_list)) return;

            switch (_row) {
                case 2:
                    if (adiciona_ao_inventario(_dev.item_id, _dev.item_qty)) {
                        gc_dev_message("Item adicionado x" + string(_dev.item_qty));
                    }
                    else {
                        gc_dev_message("Inventario sem espaco");
                    }
                break;

                case 3:
                    if (remove_do_inventario(_dev.item_id, _dev.item_qty)) {
                        gc_dev_message("Item removido x" + string(_dev.item_qty));
                    }
                    else {
                        gc_dev_message("Quantidade insuficiente");
                    }
                break;

                case 4:
                    if (_dev.confirm_danger == "clear_inventory") {
                        gc_dev_clear_inventory();
                        _dev.confirm_danger = "";
                    }
                    else {
                        _dev.confirm_danger = "clear_inventory";
                        gc_dev_message("ENTER novamente para limpar inventario");
                    }
                break;

                case 6:
                    var _item = global.itens[| _dev.item_id];

                    if (is_struct(_item)) {
                        global.item_player = _item;
                        gc_dev_message("Equipado: " + _item.nome);
                    }
                break;
            }
        break;

        case 2:
            var _flags = gc_dev_flags();

            switch (_row) {
                case 5:
                    gc_state_area_set(
                        _dev.area_index + 1,
                        !gc_state_area_get(_dev.area_index + 1, false)
                    );
                break;

                case 7:
                    gc_state_magic_set(
                        _dev.magic_index,
                        !global.tem_magia[_dev.magic_index]
                    );
                break;

                case 11:
                    gc_dev_toggle_flag(_flags[_dev.flag_index]);
                break;
            }
        break;

        case 3:
            if (!variable_global_exists("missoes") || !is_array(global.missoes)) return;
            if (array_length(global.missoes) <= 0) return;

            var _q = global.missoes[_dev.quest_index];

            switch (_row) {
                case 4:
                    _q.status = "ativa";
                    gc_quest_track(_q.id_m);
                    gc_dev_message("Missao ativada: " + _q.nome);
                break;

                case 5:
                    if (variable_struct_exists(_q, "objetivos")
                    && is_array(_q.objetivos)) {
                        for (var _oi = 0; _oi < array_length(_q.objetivos); _oi++) {
                            _q.objetivos[_oi].current = _q.objetivos[_oi].required;
                            _q.objetivos[_oi].complete = true;
                        }
                    }

                    _q.status = "pronta";
                    gc_quest_complete(_q.id_m);
                    gc_dev_message("Missao concluida: " + _q.nome);
                break;

                case 6:
                    gc_dev_reset_quest(_q);
                break;
            }
        break;

        case 4:
            var _rooms = gc_dev_rooms();

            switch (_row) {
                case 1:
                    gc_dev_teleport(_rooms[_dev.room_index]);
                break;

                case 4:
                    global.game_state.world.visited_rooms = [];
                    gc_dev_message("Rooms visitadas resetadas");
                break;

                case 5:
                    global.game_state.world.placed_structures = [];
                    global.game_state.world.furnaces = [];
                    gc_dev_message("Estruturas persistentes resetadas");
                break;

                case 6:
                    gc_world_room_entered(room_get_name(room));
                    gc_world_restore_room(room_get_name(room));
                    gc_dev_message("WorldState reaplicado");
                break;
            }
        break;

        case 5:
            switch (_row) {
                case 1:
                    if (variable_global_exists("salva_jogo")) {
                        global.salva_jogo(_dev.save_slot);
                        gc_dev_message("Slot " + string(_dev.save_slot) + " salvo");
                    }
                break;

                case 2:
                    if (variable_global_exists("carrega_jogo")) {
                        global.carrega_jogo(_dev.save_slot);
                    }
                break;

                case 3:
                    if (_dev.confirm_danger == "delete_save") {
                        global.delete_save_slot(_dev.save_slot);
                        _dev.confirm_danger = "";
                        gc_dev_message("Slot apagado");
                    }
                    else {
                        _dev.confirm_danger = "delete_save";
                        gc_dev_message("ENTER novamente para apagar o slot");
                    }
                break;

                case 4:
                    window_set_fullscreen(!window_get_fullscreen());
                break;

                case 5:
                    global.game_state.runtime.debug_open =
                        !global.game_state.runtime.debug_open;
                break;

                case 8:
                    gc_game_state_debug_print();
                    gc_dev_message("GameState enviado ao Output");
                break;

                case 9:
                    if (_dev.confirm_danger == "reset_run") {
                        gc_game_state_new_run();
                        _dev.confirm_danger = "";
                        gc_dev_message("Campanha resetada");
                    }
                    else {
                        _dev.confirm_danger = "reset_run";
                        gc_dev_message("ENTER novamente para RESETAR CAMPANHA");
                    }
                break;
            }
        break;
    }
}

function gc_dev_step(_manager) {
    var _dev = gc_dev_setup();

    if (_dev.message_timer > 0) {
        _dev.message_timer--;
    }
    else {
        _dev.message = "";
    }

    // F9 sempre abre/fecha o console.
    if (keyboard_check_pressed(vk_f9)) {
        gc_dev_toggle();
        return;
    }

    if (!_dev.open) return;

    global.pause = true;
    global.game_state.runtime.pause = true;
    global.game_state.runtime.dev_mode = true;
    global.game_state.runtime.modal_ui = "dev_console";

    var _tabs = gc_dev_tabs();

    var _tab_delta =
        keyboard_check_pressed(ord("E"))
        - keyboard_check_pressed(ord("Q"));

    if (_tab_delta != 0) {
        _dev.tab = (_dev.tab + _tab_delta + array_length(_tabs)) mod array_length(_tabs);
        _dev.row = 0;
        _dev.confirm_danger = "";
    }

    var _row_count = gc_dev_row_count(_dev.tab);

    if (keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W"))) {
        _dev.row = (_dev.row - 1 + _row_count) mod _row_count;
        _dev.confirm_danger = "";
    }

    if (keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S"))) {
        _dev.row = (_dev.row + 1) mod _row_count;
        _dev.confirm_danger = "";
    }

    var _delta =
        keyboard_check_pressed(vk_right)
        + keyboard_check_pressed(ord("D"))
        - keyboard_check_pressed(vk_left)
        - keyboard_check_pressed(ord("A"));

    if (_delta != 0) {
        gc_dev_apply_delta(_manager, sign(_delta));
        _dev.confirm_danger = "";
    }

    if (keyboard_check_pressed(vk_enter)
    || gamepad_button_check_pressed(global.controle, gp_face1)) {
        gc_dev_confirm(_manager);
    }

    if (keyboard_check_pressed(vk_escape)) {
        gc_dev_close();
    }

    // Mouse: tabs + linhas.
    var _gw = display_get_gui_width();
    var _gh = display_get_gui_height();
    var _mx = device_mouse_x_to_gui(0);
    var _my = device_mouse_y_to_gui(0);

    var _panel_x = 36;
    var _panel_y = 28;
    var _panel_w = _gw - 72;

    var _tab_w = _panel_w / array_length(_tabs);

    for (var _ti = 0; _ti < array_length(_tabs); _ti++) {
        if (point_in_rectangle(
            _mx, _my,
            _panel_x + _ti * _tab_w,
            _panel_y + 58,
            _panel_x + (_ti + 1) * _tab_w,
            _panel_y + 94
        )) {
            if (mouse_check_button_pressed(mb_left)) {
                _dev.tab = _ti;
                _dev.row = 0;
                _dev.confirm_danger = "";
            }
        }
    }

    var _row_y0 = _panel_y + 128;
    var _row_h = 36;
    var _rows = gc_dev_row_count(_dev.tab);

    for (var _ri = 0; _ri < _rows; _ri++) {
        if (point_in_rectangle(
            _mx, _my,
            _panel_x + 24,
            _row_y0 + _ri * _row_h,
            _panel_x + _panel_w - 24,
            _row_y0 + (_ri + 1) * _row_h - 2
        )) {
            _dev.row = _ri;

            if (mouse_check_button_pressed(mb_left)) {
                gc_dev_confirm(_manager);
            }
        }
    }

    // Rodinha do mouse altera o valor da linha selecionada.
    var _wheel = mouse_wheel_up() - mouse_wheel_down();

    if (_wheel != 0) {
        gc_dev_apply_delta(_manager, sign(_wheel));
        _dev.confirm_danger = "";
    }
}

function gc_dev_player_rows() {
    var _out = [];

    if (!instance_exists(obj_sdash)) {
        return [
            "Sdash nao existe",
            "-", "-", "-", "-", "-", "-", "-"
        ];
    }

    var _s = instance_find(obj_sdash, 0);

    return [
        "Vida: " + string(_s.vida),
        "Vida maxima: " + string(_s.max_vida),
        "Estamina: " + string(round(_s.estamina)),
        "Estamina maxima: " + string(round(_s.max_estamina)),
        "X: " + string(round(_s.x)),
        "Y: " + string(round(_s.y)),
        "[ENTER] Restaurar vida + estamina",
        "[ENTER] Deixar com 1 HP"
    ];
}

function gc_dev_inventory_rows(_dev) {
    var _item_name = "sem itens";

    if (variable_global_exists("itens")
    && ds_exists(global.itens, ds_type_list)
    && ds_list_size(global.itens) > 0) {
        _dev.item_id = clamp(_dev.item_id, 0, ds_list_size(global.itens) - 1);
        var _item = global.itens[| _dev.item_id];

        if (is_struct(_item)) _item_name = _item.nome;
    }

    return [
        "Item selecionado: [" + string(_dev.item_id) + "] " + _item_name,
        "Quantidade: " + string(_dev.item_qty),
        "[ENTER] Adicionar item",
        "[ENTER] Remover item",
        "[ENTER x2] Limpar inventario",
        "Moedas: " + string(global.moedas),
        "[ENTER] Equipar item selecionado"
    ];
}

function gc_dev_campaign_rows(_dev) {
    var _reps = gc_dev_reputations();
    var _counters = gc_dev_counters();
    var _flags = gc_dev_flags();

    var _rep = _reps[_dev.reputation_index];
    var _counter = _counters[_dev.counter_index];
    var _flag = _flags[_dev.flag_index];

    return [
        "Capitulo: " + string(global.game_state.campaign.chapter),
        "Etapa: " + string(global.game_state.campaign.stage),
        "Reputacao selecionada: " + _rep,
        _rep + ": " + string(gc_state_reputation_get(_rep, 0)),
        "Area selecionada: " + string(_dev.area_index + 1),
        "[ENTER] Area " + string(_dev.area_index + 1) + ": "
            + (gc_state_area_get(_dev.area_index + 1, false) ? "LIBERADA" : "BLOQUEADA"),
        "Magia selecionada: " + string(_dev.magic_index + 1),
        "[ENTER] Magia " + string(_dev.magic_index + 1) + ": "
            + ((is_array(global.tem_magia) && global.tem_magia[_dev.magic_index]) ? "ON" : "OFF"),
        "Contador selecionado: " + _counter,
        _counter + ": " + string(gc_state_counter_get(_counter, 0)),
        "Flag selecionada: " + _flag,
        "[ENTER] " + _flag + ": " + (gc_dev_get_flag(_flag) ? "true" : "false")
    ];
}

function gc_dev_quest_rows(_dev) {
    if (!variable_global_exists("missoes")
    || !is_array(global.missoes)
    || array_length(global.missoes) <= 0) {
        return [
            "Nenhuma missao",
            "-", "-", "-", "-", "-", "-"
        ];
    }

    _dev.quest_index = clamp(_dev.quest_index, 0, array_length(global.missoes) - 1);

    var _q = global.missoes[_dev.quest_index];
    var _obj_text = "sem objetivos";
    var _prog_text = "-";

    if (variable_struct_exists(_q, "objetivos")
    && is_array(_q.objetivos)
    && array_length(_q.objetivos) > 0) {
        _dev.objective_index = clamp(
            _dev.objective_index,
            0,
            array_length(_q.objetivos) - 1
        );

        var _o = _q.objetivos[_dev.objective_index];

        _obj_text = _o.label;
        _prog_text = string(_o.current) + "/" + string(_o.required);
    }

    return [
        "Missao: [" + string(_dev.quest_index) + "] " + _q.nome,
        "Status: " + _q.status,
        "Objetivo: [" + string(_dev.objective_index) + "] " + _obj_text,
        "Progresso: " + _prog_text,
        "[ENTER] Ativar / rastrear",
        "[ENTER] Concluir missao",
        "[ENTER] Resetar missao"
    ];
}

function gc_dev_world_rows(_dev) {
    var _rooms = gc_dev_rooms();
    _dev.room_index = clamp(_dev.room_index, 0, array_length(_rooms) - 1);

    var _room_asset = _rooms[_dev.room_index];
    var _x = instance_exists(obj_sdash) ? round(instance_find(obj_sdash, 0).x) : 0;
    var _y = instance_exists(obj_sdash) ? round(instance_find(obj_sdash, 0).y) : 0;

    return [
        "Room destino: " + room_get_name(_room_asset),
        "[ENTER] TELEPORTAR",
        "Player X: " + string(_x),
        "Player Y: " + string(_y),
        "[ENTER] Limpar rooms visitadas",
        "[ENTER] Limpar estruturas persistentes",
        "[ENTER] Reaplicar WorldState da room atual"
    ];
}

function gc_dev_save_rows(_dev) {
    var _difs = ["FACIL", "NORMAL", "DIFICIL"];
    var _fullscreen = window_get_fullscreen();

    return [
        "Slot selecionado: " + string(_dev.save_slot),
        "[ENTER] Salvar slot",
        "[ENTER] Carregar slot",
        "[ENTER x2] Apagar slot",
        "[ENTER] Fullscreen: " + (_fullscreen ? "ON" : "OFF"),
        "[ENTER] Overlay F10: " + (global.game_state.runtime.debug_open ? "ON" : "OFF"),
        "Volume: " + string(round(global.volume_mestre * 100)) + "%",
        "Dificuldade: " + _difs[global.dificuldade],
        "[ENTER] Imprimir GameState no Output",
        "[ENTER x2] RESETAR CAMPANHA"
    ];
}

function gc_dev_draw(_manager) {
    var _dev = gc_dev_setup();
    if (!_dev.open) return;

    var _gw = display_get_gui_width();
    var _gh = display_get_gui_height();

    var _panel_x = 36;
    var _panel_y = 28;
    var _panel_w = _gw - 72;
    var _panel_h = _gh - 56;

    draw_set_alpha(0.93);
    draw_set_color(make_color_rgb(8, 10, 18));
    draw_rectangle(0, 0, _gw, _gh, false);

    draw_set_alpha(0.98);
    draw_set_color(make_color_rgb(20, 22, 32));
    draw_rectangle(
        _panel_x,
        _panel_y,
        _panel_x + _panel_w,
        _panel_y + _panel_h,
        false
    );

    draw_set_alpha(1);
    draw_set_color(c_fuchsia);
    draw_rectangle(
        _panel_x + 3,
        _panel_y + 3,
        _panel_x + _panel_w - 3,
        _panel_y + _panel_h - 3,
        true
    );

    draw_set_font(fnt_geocraft);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);

    draw_set_color(c_fuchsia);
    draw_text(_panel_x + 22, _panel_y + 18, "GEOCRAFT DEV CONSOLE");

    draw_set_font(fnt_dialogo_small);
    draw_set_color(c_gray);
    draw_text(
        _panel_x + 22,
        _panel_y + 44,
        "F9/Esc fecha  |  Q/E abas  |  W/S linha  |  A/D ou roda altera  |  Enter executa"
    );

    var _tabs = gc_dev_tabs();
    var _tab_w = _panel_w / array_length(_tabs);

    for (var _ti = 0; _ti < array_length(_tabs); _ti++) {
        var _tx1 = _panel_x + _ti * _tab_w;
        var _tx2 = _panel_x + (_ti + 1) * _tab_w;
        var _selected_tab = (_ti == _dev.tab);

        draw_set_alpha(_selected_tab ? 0.55 : 0.18);
        draw_set_color(_selected_tab ? c_fuchsia : c_black);
        draw_rectangle(_tx1, _panel_y + 58, _tx2, _panel_y + 94, false);
        draw_set_alpha(1);

        draw_set_halign(fa_center);
        draw_set_color(_selected_tab ? c_yellow : c_white);
        draw_text((_tx1 + _tx2) * 0.5, _panel_y + 69, _tabs[_ti]);
    }

    draw_set_halign(fa_left);

    var _rows = [];

    switch (_dev.tab) {
        case 0: _rows = gc_dev_player_rows(); break;
        case 1: _rows = gc_dev_inventory_rows(_dev); break;
        case 2: _rows = gc_dev_campaign_rows(_dev); break;
        case 3: _rows = gc_dev_quest_rows(_dev); break;
        case 4: _rows = gc_dev_world_rows(_dev); break;
        case 5: _rows = gc_dev_save_rows(_dev); break;
    }

    var _row_y0 = _panel_y + 128;
    var _row_h = 36;

    for (var _ri = 0; _ri < array_length(_rows); _ri++) {
        var _yy = _row_y0 + _ri * _row_h;
        var _selected = (_ri == _dev.row);

        draw_set_alpha(_selected ? 0.32 : 0.08);
        draw_set_color(_selected ? c_fuchsia : c_white);
        draw_rectangle(
            _panel_x + 24,
            _yy,
            _panel_x + _panel_w - 24,
            _yy + _row_h - 2,
            false
        );
        draw_set_alpha(1);

        draw_set_color(_selected ? c_yellow : c_white);
        draw_text(
            _panel_x + 38,
            _yy + 9,
            (_selected ? "> " : "  ") + _rows[_ri]
        );
    }

    draw_set_color(c_gray);
    draw_text(
        _panel_x + 24,
        _panel_y + _panel_h - 58,
        "Room: " + room_get_name(room)
        + " | FPS: " + string(round(fps_real))
        + " | Slot: " + string(variable_global_exists("save_slot") ? global.save_slot : 1)
    );

    if (string_length(_dev.message) > 0) {
        draw_set_color(c_aqua);
        draw_text(
            _panel_x + 24,
            _panel_y + _panel_h - 32,
            _dev.message
        );
    }

    draw_set_alpha(1);
    draw_set_color(c_white);
    draw_set_font(-1);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

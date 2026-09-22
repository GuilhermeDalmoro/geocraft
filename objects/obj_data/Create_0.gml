/// Save/Load v5 - 3 slots + backup + GameState + migracao de saves antigos.

if (instance_number(obj_data) > 1) {
    instance_destroy();
    exit;
}

if (!variable_global_exists("save_slot")) {
    global.save_slot = 1;
}

function gc_save_slot_clamp(_slot) {
    return clamp(round(_slot), 1, 3);
}

function gc_save_path(_slot) {
    _slot = gc_save_slot_clamp(_slot);
    return "save_slot_" + string(_slot) + ".json";
}

function gc_save_backup_path(_slot) {
    _slot = gc_save_slot_clamp(_slot);
    return "save_slot_" + string(_slot) + "_backup.json";
}

function gc_save_remember_slot(_slot) {
    _slot = gc_save_slot_clamp(_slot);

    ini_open("config.ini");
    ini_write_real("save", "last_slot", _slot);
    ini_close();
}

function gc_save_item_id() {
    if (!variable_global_exists("item_player")) return -1;
    if (global.item_player == noone || !is_struct(global.item_player)) return -1;
    if (!variable_struct_exists(global.item_player, "id")) return -1;
    return global.item_player.id;
}

function gc_load_item_from_id(_id) {
    if (_id < 0) return noone;
    if (!variable_global_exists("itens")) return noone;
    if (!ds_exists(global.itens, ds_type_list)) return noone;
    if (_id >= ds_list_size(global.itens)) return noone;
    return global.itens[| _id];
}

function gc_ensure_inventory_grid() {
    if (!variable_global_exists("inventario_slots")
    || !ds_exists(global.inventario_slots, ds_type_grid)) {
        global.inventario_slots = ds_grid_create(8, 4);
        ds_grid_clear(global.inventario_slots, 0);
    }
}

function gc_save_read_raw(_path) {
    if (!file_exists(_path)) return "";

    var _file = file_text_open_read(_path);
    if (_file < 0) return "";

    var _text = file_text_read_string(_file);
    file_text_close(_file);

    return _text;
}

function gc_save_write_raw(_path, _text) {
    var _file = file_text_open_write(_path);
    if (_file < 0) return false;

    file_text_write_string(_file, _text);
    file_text_close(_file);

    return true;
}

function gc_save_parse_safe(_text) {
    if (string_length(_text) <= 0) return noone;

    try {
        var _parsed = json_parse(_text);
        return is_struct(_parsed) ? _parsed : noone;
    }
    catch (_exception) {
        show_debug_message("[SAVE] JSON invalido: " + string(_exception));
        return noone;
    }
}

function gc_session_cleanup() {
    // Mantem obj_data vivo porque ele e o save manager do menu.
    with (obj_dev_console) instance_destroy();
    with (obj_dialogo) instance_destroy();
    with (obj_fornalha_ui) instance_destroy();
    with (obj_shop_int_1) instance_destroy();
    with (obj_transition) instance_destroy();

    with (obj_sdash) instance_destroy();
    with (obj_picareta) instance_destroy();
    with (obj_seletor) instance_destroy();

    with (obj_inventario) instance_destroy();
    with (obj_controle_hud) instance_destroy();
    with (obj_slot_magia) instance_destroy();
    with (obj_minimap) instance_destroy();
    with (obj_misson_manager) instance_destroy();
    with (obj_pause) instance_destroy();

    global.pause = false;
    global.pause_por_inventario = false;
    global.dialogo_acontecendo = false;

    if (variable_global_exists("game_state") && is_struct(global.game_state)) {
        global.game_state.runtime.pause = false;
        global.game_state.runtime.pause_por_inventario = false;
        global.game_state.runtime.dialogo_acontecendo = false;
        global.game_state.runtime.modal_ui = "";
        global.game_state.runtime.interaction_lock = 0;
    }
}

function gc_session_bootstrap_for_load() {
    // Carregar diretamente para uma room avancada precisa dos objetos persistentes
    // que normalmente nasceriam em Room1.
    if (!instance_exists(obj_inventario)) {
        instance_create_layer(0, 0, "Instances", obj_inventario);
    }

    if (!instance_exists(obj_misson_manager)) {
        instance_create_layer(0, 0, "Instances", obj_misson_manager);
    }

    if (!instance_exists(obj_pause)) {
        instance_create_layer(0, 0, "Instances", obj_pause);
    }

    if (!instance_exists(obj_controle_hud)) {
        instance_create_layer(0, 0, "Instances", obj_controle_hud);
    }

    if (!instance_exists(obj_slot_magia)) {
        instance_create_layer(0, 0, "Instances", obj_slot_magia);
    }

    if (!instance_exists(obj_minimap)) {
        instance_create_layer(0, 0, "Instances", obj_minimap);
    }
}

global.save_slot_exists = function(_slot) {
    _slot = gc_save_slot_clamp(_slot);

    if (file_exists(gc_save_path(_slot))) return true;

    // Migracao do save unico antigo para o slot 1.
    if (_slot == 1 && file_exists("save.json")) return true;

    return false;
};

global.save_slot_meta = function(_slot) {
    _slot = gc_save_slot_clamp(_slot);

    var _path = gc_save_path(_slot);

    if (!file_exists(_path) && _slot == 1 && file_exists("save.json")) {
        _path = "save.json";
    }

    var _data = gc_save_parse_safe(gc_save_read_raw(_path));

    if (_data == noone || !variable_struct_exists(_data, "sdash")) {
        return {
            exists : false,
            slot : _slot,
            room_name : "",
            moedas : 0,
            vida : 0,
            max_vida : 0,
            stage : ""
        };
    }

    var _room_name = variable_struct_exists(_data.sdash, "room_name")
        ? string(_data.sdash.room_name)
        : "Save antigo";

    var _vida = variable_struct_exists(_data.sdash, "vida") ? _data.sdash.vida : 0;
    var _max_vida = variable_struct_exists(_data.sdash, "max_vida")
        ? _data.sdash.max_vida
        : (variable_struct_exists(_data.sdash, "mvida") ? _data.sdash.mvida : 0);

    var _coins = 0;
    var _stage = "";

    if (variable_struct_exists(_data, "game_state") && is_struct(_data.game_state)) {
        var _gs = _data.game_state;

        if (variable_struct_exists(_gs, "campaign") && is_struct(_gs.campaign)) {
            if (variable_struct_exists(_gs.campaign, "stage")) {
                _stage = string(_gs.campaign.stage);
            }

            if (variable_struct_exists(_gs.campaign, "economy")
            && is_struct(_gs.campaign.economy)
            && variable_struct_exists(_gs.campaign.economy, "moedas")) {
                _coins = _gs.campaign.economy.moedas;
            }
        }
    }
    else if (variable_struct_exists(_data.sdash, "moedas")) {
        _coins = _data.sdash.moedas;
    }

    return {
        exists : true,
        slot : _slot,
        room_name : _room_name,
        moedas : _coins,
        vida : _vida,
        max_vida : _max_vida,
        stage : _stage
    };
};

global.delete_save_slot = function(_slot) {
    _slot = gc_save_slot_clamp(_slot);

    var _path = gc_save_path(_slot);
    var _backup = gc_save_backup_path(_slot);

    if (file_exists(_path)) file_delete(_path);
    if (file_exists(_backup)) file_delete(_backup);

    // Se o usuario explicitamente apagar o slot 1, remove o save legado tambem.
    if (_slot == 1 && file_exists("save.json")) {
        file_delete("save.json");
    }

    return true;
};

global.novo_jogo = function(_slot) {
    _slot = gc_save_slot_clamp(_slot);
    global.save_slot = _slot;
    gc_save_remember_slot(_slot);

    gc_session_cleanup();
    global.delete_save_slot(_slot);
    gc_game_state_new_run();

    // Room_intro leva ao fluxo normal do jogo, onde os controladores sao criados.
    room_goto(Room_intro);
    return true;
};

global.voltar_menu = function() {
    gc_session_cleanup();
    room_goto(room_menu);
    return true;
};

global.salva_jogo = function(_slot = global.save_slot) {
    _slot = gc_save_slot_clamp(_slot);
    global.save_slot = _slot;
    gc_save_remember_slot(_slot);

    if (!instance_exists(obj_sdash)) {
        show_debug_message("[SAVE] Cancelado: Sdash nao existe.");
        return false;
    }

    gc_ensure_inventory_grid();
    gc_game_state_sync_from_legacy();

    var _sdash = instance_find(obj_sdash, 0);
    var _inv = [];
    var _w = ds_grid_width(global.inventario_slots);
    var _h = ds_grid_height(global.inventario_slots);

    for (var _x = 0; _x < _w; _x++) {
        _inv[_x] = [];

        for (var _y = 0; _y < _h; _y++) {
            _inv[_x][_y] = global.inventario_slots[# _x, _y];
        }
    }

    var _dados = {
        save_version : 5,
        save_slot : _slot,

        sdash : {
            x : _sdash.x,
            y : _sdash.y,
            room_name : room_get_name(room),

            vida : _sdash.vida,
            max_vida : _sdash.max_vida,

            estamina : _sdash.estamina,
            max_estamina : _sdash.max_estamina,

            item_id : gc_save_item_id(),
            magia_selecionada : global.magia_selecionada
        },

        inventario : _inv,
        game_state : gc_game_state_export()
    };

    var _string = json_stringify(_dados);
    var _path = gc_save_path(_slot);
    var _backup = gc_save_backup_path(_slot);

    if (file_exists(_path)) {
        var _old_save = gc_save_read_raw(_path);

        if (string_length(_old_save) > 0) {
            gc_save_write_raw(_backup, _old_save);
        }
    }

    if (!gc_save_write_raw(_path, _string)) {
        show_debug_message("[SAVE] Falha ao gravar " + _path);
        return false;
    }

    gc_quest_toast("Jogo salvo no Slot " + string(_slot), 90);
    show_debug_message("[SAVE] Slot " + string(_slot) + " salvo.");
    return true;
};

global.carrega_jogo = function(_slot = global.save_slot) {
    _slot = gc_save_slot_clamp(_slot);
    global.save_slot = _slot;
    gc_save_remember_slot(_slot);

    var _path = gc_save_path(_slot);
    var _backup_path = gc_save_backup_path(_slot);

    // Slot 1 importa o save unico antigo automaticamente.
    if (!file_exists(_path) && _slot == 1 && file_exists("save.json")) {
        _path = "save.json";
    }

    var _string = gc_save_read_raw(_path);
    var _dados = gc_save_parse_safe(_string);
    var _using_backup = false;

    if (_dados == noone) {
        var _backup = gc_save_read_raw(_backup_path);
        _dados = gc_save_parse_safe(_backup);

        if (_dados != noone) {
            _using_backup = true;
            show_debug_message("[LOAD] Save principal invalido; usando backup.");
        }
    }

    if (_dados == noone || !variable_struct_exists(_dados, "sdash")) {
        show_debug_message("[LOAD] Nenhum save valido no slot " + string(_slot));
        return false;
    }

    gc_session_cleanup();
    gc_session_bootstrap_for_load();
    gc_ensure_inventory_grid();

    if (variable_struct_exists(_dados, "game_state") && is_struct(_dados.game_state)) {
        gc_game_state_import(_dados.game_state);
        gc_quest_repair_progression();
    }
    else {
        if (variable_struct_exists(_dados.sdash, "m_inimigos")) {
            global.inimigos_mortos = _dados.sdash.m_inimigos;
        }

        if (variable_struct_exists(_dados.sdash, "moedas")) {
            global.moedas = _dados.sdash.moedas;
        }

        gc_game_state_bootstrap();
        gc_game_state_sync_from_legacy();
    }

    if (variable_struct_exists(_dados, "inventario") && is_array(_dados.inventario)) {
        var _iw = ds_grid_width(global.inventario_slots);
        var _ih = ds_grid_height(global.inventario_slots);

        ds_grid_clear(global.inventario_slots, 0);

        for (var _ix = 0; _ix < min(_iw, array_length(_dados.inventario)); _ix++) {
            if (!is_array(_dados.inventario[_ix])) continue;

            for (var _iy = 0; _iy < min(_ih, array_length(_dados.inventario[_ix])); _iy++) {
                global.inventario_slots[# _ix, _iy] = _dados.inventario[_ix][_iy];
            }
        }
    }

    var _item_id = -1;

    if (variable_struct_exists(_dados.sdash, "item_id")) {
        _item_id = _dados.sdash.item_id;
    }
    else if (variable_struct_exists(_dados.sdash, "item_atual")
    && is_struct(_dados.sdash.item_atual)
    && variable_struct_exists(_dados.sdash.item_atual, "id")) {
        _item_id = _dados.sdash.item_atual.id;
    }

    global.item_player = gc_load_item_from_id(_item_id);

    var _sx = variable_struct_exists(_dados.sdash, "x")
        ? _dados.sdash.x
        : (variable_struct_exists(_dados.sdash, "meux") ? _dados.sdash.meux : 0);

    var _sy = variable_struct_exists(_dados.sdash, "y")
        ? _dados.sdash.y
        : (variable_struct_exists(_dados.sdash, "meuy") ? _dados.sdash.meuy : 0);

    var _vida = variable_struct_exists(_dados.sdash, "vida") ? _dados.sdash.vida : 10;

    var _max_vida = variable_struct_exists(_dados.sdash, "max_vida")
        ? _dados.sdash.max_vida
        : (variable_struct_exists(_dados.sdash, "mvida") ? _dados.sdash.mvida : 10);

    var _estamina = variable_struct_exists(_dados.sdash, "estamina") ? _dados.sdash.estamina : 120;
    var _max_estamina = variable_struct_exists(_dados.sdash, "max_estamina") ? _dados.sdash.max_estamina : 120;

    if (variable_struct_exists(_dados.sdash, "magia_selecionada")) {
        global.magia_selecionada = _dados.sdash.magia_selecionada;
    }

    var _target_room = Room1;

    if (variable_struct_exists(_dados.sdash, "room_name")) {
        var _room_asset = asset_get_index(_dados.sdash.room_name);
        if (_room_asset != -1) _target_room = _room_asset;
    }
    else if (variable_struct_exists(_dados.sdash, "rm")) {
        _target_room = _dados.sdash.rm;
    }

    var _sdash = instance_create_layer(0, 0, "Instances", obj_sdash);

    _sdash.max_vida = max(1, _max_vida);
    _sdash.vida = clamp(_vida, 0, _sdash.max_vida);

    _sdash.max_estamina = max(1, _max_estamina);
    _sdash.estamina = clamp(_estamina, 0, _sdash.max_estamina);

    _sdash.active = true;
    _sdash.magia_cooldown = 0;

    global.pause = false;
    global.pause_por_inventario = false;
    global.dialogo_acontecendo = false;

    global.game_state.runtime.pause = false;
    global.game_state.runtime.pause_por_inventario = false;
    global.game_state.runtime.dialogo_acontecendo = false;
    global.game_state.runtime.quest_journal_open = false;

    gc_game_state_sync_from_legacy();

    if (room != _target_room) {
        var _transition = instance_create_layer(0, 0, "Instances", obj_transition);
        _transition.target_room = _target_room;
        _transition.target_x = _sx;
        _transition.target_y = _sy;
    }
    else {
        _sdash.x = _sx;
        _sdash.y = _sy;

        gc_world_room_entered(room_get_name(room));
        gc_world_restore_room(room_get_name(room));
    }

    gc_quest_toast(
        _using_backup
            ? "Backup do Slot " + string(_slot) + " carregado"
            : "Slot " + string(_slot) + " carregado",
        100
    );

    show_debug_message("[LOAD] Slot " + string(_slot) + " carregado.");
    return true;
};

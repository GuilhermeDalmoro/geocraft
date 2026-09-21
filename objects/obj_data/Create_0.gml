/// Save/Load v4 - Sdash + inventario + GameState + missoes + backup.

if (instance_number(obj_data) > 1) {
    instance_destroy();
    exit;
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

global.salva_jogo = function() {
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
        save_version : 4,

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

    // O ultimo save valido vira backup antes de sobrescrever o principal.
    if (file_exists("save.json")) {
        var _old_save = gc_save_read_raw("save.json");

        if (string_length(_old_save) > 0) {
            gc_save_write_raw("save_backup.json", _old_save);
        }
    }

    if (!gc_save_write_raw("save.json", _string)) {
        show_debug_message("[SAVE] Falha ao gravar save.json.");
        return false;
    }

    gc_quest_toast("Jogo salvo", 90);
    show_debug_message("[SAVE] Save v4 concluido.");
    return true;
};

global.carrega_jogo = function() {
    gc_ensure_inventory_grid();

    var _string = gc_save_read_raw("save.json");
    var _dados = gc_save_parse_safe(_string);
    var _using_backup = false;

    if (_dados == noone) {
        var _backup = gc_save_read_raw("save_backup.json");
        _dados = gc_save_parse_safe(_backup);

        if (_dados != noone) {
            _using_backup = true;
            show_debug_message("[LOAD] Save principal invalido; usando backup.");
        }
    }

    if (_dados == noone || !variable_struct_exists(_dados, "sdash")) {
        show_debug_message("[LOAD] Nenhum save valido encontrado.");
        gc_quest_toast("Nao foi possivel carregar o save", 120);
        return false;
    }

    // Estado novo. Saves antigos continuam tendo fallback.
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

    // Inventario.
    if (variable_struct_exists(_dados, "inventario") && is_array(_dados.inventario)) {
        var _w = ds_grid_width(global.inventario_slots);
        var _h = ds_grid_height(global.inventario_slots);

        ds_grid_clear(global.inventario_slots, 0);

        for (var _x = 0; _x < min(_w, array_length(_dados.inventario)); _x++) {
            if (!is_array(_dados.inventario[_x])) continue;

            for (var _y = 0; _y < min(_h, array_length(_dados.inventario[_x])); _y++) {
                global.inventario_slots[# _x, _y] = _dados.inventario[_x][_y];
            }
        }
    }

    // Item equipado: saves atuais usam ID; antigos tentam recuperar o ID do struct.
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

    // Compatibilidade com nomes de campos antigos.
    var _sx = 0;
    var _sy = 0;
    var _vida = 10;
    var _max_vida = 10;
    var _estamina = 120;
    var _max_estamina = 120;

    if (variable_struct_exists(_dados.sdash, "x")) _sx = _dados.sdash.x;
    else if (variable_struct_exists(_dados.sdash, "meux")) _sx = _dados.sdash.meux;

    if (variable_struct_exists(_dados.sdash, "y")) _sy = _dados.sdash.y;
    else if (variable_struct_exists(_dados.sdash, "meuy")) _sy = _dados.sdash.meuy;

    if (variable_struct_exists(_dados.sdash, "vida")) _vida = _dados.sdash.vida;

    if (variable_struct_exists(_dados.sdash, "max_vida")) _max_vida = _dados.sdash.max_vida;
    else if (variable_struct_exists(_dados.sdash, "mvida")) _max_vida = _dados.sdash.mvida;

    if (variable_struct_exists(_dados.sdash, "estamina")) {
        _estamina = _dados.sdash.estamina;
    }

    if (variable_struct_exists(_dados.sdash, "max_estamina")) {
        _max_estamina = _dados.sdash.max_estamina;
    }

    if (variable_struct_exists(_dados.sdash, "magia_selecionada")) {
        global.magia_selecionada = _dados.sdash.magia_selecionada;
    }

    var _target_room = room;

    if (variable_struct_exists(_dados.sdash, "room_name")) {
        var _room_asset = asset_get_index(_dados.sdash.room_name);

        if (_room_asset != -1) {
            _target_room = _room_asset;
        }
    }
    else if (variable_struct_exists(_dados.sdash, "rm")) {
        _target_room = _dados.sdash.rm;
    }

    var _sdash = noone;

    if (instance_exists(obj_sdash)) {
        _sdash = instance_find(obj_sdash, 0);
    }
    else {
        _sdash = instance_create_layer(0, 0, "Instances", obj_sdash);
    }

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
        if (instance_exists(obj_transition)) {
            with (obj_transition) instance_destroy();
        }

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
        _using_backup ? "Backup carregado com sucesso" : "Jogo carregado",
        100
    );

    show_debug_message("[LOAD] Save carregado com sucesso.");
    return true;
};

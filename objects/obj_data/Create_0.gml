/// Save/Load v3 - inventario + Sdash + GameState + missoes.

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
        save_version : 3,

        sdash : {
            x : _sdash.x,
            y : _sdash.y,
            room_name : room_get_name(room),
            vida : _sdash.vida,
            max_vida : _sdash.max_vida,
            item_id : gc_save_item_id()
        },

        inventario : _inv,
        game_state : gc_game_state_export()
    };

    var _string = json_stringify(_dados);
    var _file = file_text_open_write("save.json");

    if (_file < 0) {
        show_debug_message("[SAVE] Falha ao abrir save.json.");
        return false;
    }

    file_text_write_string(_file, _string);
    file_text_close(_file);

    gc_quest_toast("Jogo salvo", 100);
    show_debug_message("[SAVE] Save v3 concluido.");
    return true;
};

global.carrega_jogo = function() {
    if (!file_exists("save.json")) {
        show_debug_message("[LOAD] Nenhum save encontrado.");
        return false;
    }

    gc_ensure_inventory_grid();

    var _file = file_text_open_read("save.json");
    if (_file < 0) {
        show_debug_message("[LOAD] Falha ao abrir save.json.");
        return false;
    }

    var _string = file_text_read_string(_file);
    file_text_close(_file);

    if (string_length(_string) <= 0) {
        show_debug_message("[LOAD] save.json vazio.");
        return false;
    }

    var _dados = json_parse(_string);
    if (!is_struct(_dados) || !variable_struct_exists(_dados, "sdash")) {
        show_debug_message("[LOAD] Formato de save invalido.");
        return false;
    }

    // Estado novo. Saves antigos continuam tendo fallback abaixo.
    if (variable_struct_exists(_dados, "game_state") && is_struct(_dados.game_state)) {
        gc_game_state_import(_dados.game_state);
    }
    else {
        // Migracao do save antigo.
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

    // Item equipado: v3 usa ID. Saves antigos tentam recuperar o ID do struct.
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

    // Compatibilidade de nomes de campos antigos.
    var _sx = 0;
    var _sy = 0;
    var _vida = 10;
    var _max_vida = 10;

    if (variable_struct_exists(_dados.sdash, "x")) _sx = _dados.sdash.x;
    else if (variable_struct_exists(_dados.sdash, "meux")) _sx = _dados.sdash.meux;

    if (variable_struct_exists(_dados.sdash, "y")) _sy = _dados.sdash.y;
    else if (variable_struct_exists(_dados.sdash, "meuy")) _sy = _dados.sdash.meuy;

    if (variable_struct_exists(_dados.sdash, "vida")) _vida = _dados.sdash.vida;

    if (variable_struct_exists(_dados.sdash, "max_vida")) _max_vida = _dados.sdash.max_vida;
    else if (variable_struct_exists(_dados.sdash, "mvida")) _max_vida = _dados.sdash.mvida;

    var _target_room = room;

    if (variable_struct_exists(_dados.sdash, "room_name")) {
        var _room_asset = asset_get_index(_dados.sdash.room_name);
        if (_room_asset != -1) _target_room = _room_asset;
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

    _sdash.vida = clamp(_vida, 0, _max_vida);
    _sdash.max_vida = _max_vida;
    _sdash.active = true;

    global.pause = false;
    global.pause_por_inventario = false;
    global.dialogo_acontecendo = false;

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

    gc_quest_toast("Jogo carregado", 100);
    show_debug_message("[LOAD] Save carregado com sucesso.");
    return true;
};

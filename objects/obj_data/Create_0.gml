/// Save/Load V1.1 - compativel com o save antigo e com o novo GameState.

function gc_item_equipado_id() {
    if (!variable_global_exists("item_player")) return -1;
    if (global.item_player == noone) return -1;
    if (!is_struct(global.item_player)) return -1;
    if (!variable_struct_exists(global.item_player, "id")) return -1;
    return global.item_player.id;
}

function gc_item_por_id(_id) {
    if (_id < 0) return noone;
    if (!variable_global_exists("itens")) return noone;
    if (!ds_exists(global.itens, ds_type_list)) return noone;
    if (_id >= ds_list_size(global.itens)) return noone;
    return global.itens[| _id];
}

global.salva_jogo = function() {
    if (!instance_exists(obj_sdash)) {
        show_debug_message("[SAVE] Sdash nao existe; save cancelado.");
        return false;
    }

    if (!variable_global_exists("inventario_slots")
    || !ds_exists(global.inventario_slots, ds_type_grid)) {
        show_debug_message("[SAVE] Inventario ainda nao foi inicializado; save cancelado.");
        return false;
    }

    gc_game_state_sync_from_legacy();

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
        save_version : 2,

        sdash : {
            meux : obj_sdash.x,
            meuy : obj_sdash.y,
            rm : room,
            vida : obj_sdash.vida,
            mvida : obj_sdash.max_vida,

            // ID e estavel e seguro para JSON. Evita serializar funcoes do struct do item.
            item_atual_id : gc_item_equipado_id(),

            // Mantidos por compatibilidade/diagnostico.
            m_inimigos : global.inimigos_mortos,
            moedas : global.moedas
        },

        inventario : _inv,
        game_state : gc_game_state_export()
    };

    var _string = json_stringify(_dados);
    var _file = file_text_open_write("save.json");

    if (_file < 0) {
        show_debug_message("[SAVE] Nao foi possivel abrir save.json para escrita.");
        return false;
    }

    file_text_write_string(_file, _string);
    file_text_close(_file);

    show_debug_message("[SAVE] Save v2 concluido.");
    return true;
};


global.carrega_jogo = function() {
    if (!file_exists("save.json")) {
        show_debug_message("[LOAD] Nenhum save.json encontrado.");
        return false;
    }

    if (!variable_global_exists("inventario_slots")
    || !ds_exists(global.inventario_slots, ds_type_grid)) {
        show_debug_message("[LOAD] Inventario ainda nao foi inicializado; load cancelado.");
        return false;
    }

    var _file = file_text_open_read("save.json");
    if (_file < 0) {
        show_debug_message("[LOAD] Nao foi possivel abrir save.json.");
        return false;
    }

    var _string = file_text_read_string(_file);
    file_text_close(_file);

    var _dados = json_parse(_string);
    if (!is_struct(_dados) || !variable_struct_exists(_dados, "sdash")) {
        show_debug_message("[LOAD] Save invalido ou corrompido.");
        return false;
    }

    // Novo save: restaura primeiro o estado central.
    if (variable_struct_exists(_dados, "game_state") && is_struct(_dados.game_state)) {
        gc_game_state_import(_dados.game_state);
    } else {
        // Save antigo: preserva os campos que ja existiam.
        if (variable_struct_exists(_dados.sdash, "m_inimigos")) {
            global.inimigos_mortos = _dados.sdash.m_inimigos;
        }
        if (variable_struct_exists(_dados.sdash, "moedas")) {
            global.moedas = _dados.sdash.moedas;
        }
        gc_game_state_sync_from_legacy();
    }

    // Inventario - copia apenas dentro dos limites do grid atual.
    if (variable_struct_exists(_dados, "inventario") && is_array(_dados.inventario)) {
        var _w = ds_grid_width(global.inventario_slots);
        var _h = ds_grid_height(global.inventario_slots);

        for (var _x = 0; _x < _w; _x++) {
            if (_x >= array_length(_dados.inventario)) break;
            if (!is_array(_dados.inventario[_x])) continue;

            for (var _y = 0; _y < _h; _y++) {
                if (_y >= array_length(_dados.inventario[_x])) break;
                global.inventario_slots[# _x, _y] = _dados.inventario[_x][_y];
            }
        }
    }

    // Item equipado: novo formato por ID; fallback para saves antigos.
    global.item_player = noone;

    if (variable_struct_exists(_dados.sdash, "item_atual_id")) {
        global.item_player = gc_item_por_id(_dados.sdash.item_atual_id);
    } else if (variable_struct_exists(_dados.sdash, "item_atual")) {
        // Compatibilidade com saves legados que guardavam o struct completo.
        if (is_struct(_dados.sdash.item_atual)
        && variable_struct_exists(_dados.sdash.item_atual, "id")) {
            global.item_player = gc_item_por_id(_dados.sdash.item_atual.id);
        }
    }

    var _temp_x = variable_struct_exists(_dados.sdash, "meux") ? _dados.sdash.meux : 0;
    var _temp_y = variable_struct_exists(_dados.sdash, "meuy") ? _dados.sdash.meuy : 0;
    var _temp_room = variable_struct_exists(_dados.sdash, "rm") ? _dados.sdash.rm : room;
    var _temp_vida = variable_struct_exists(_dados.sdash, "vida") ? _dados.sdash.vida : 10;
    var _temp_max_vida = variable_struct_exists(_dados.sdash, "mvida") ? _dados.sdash.mvida : 10;

    var _sdash_inst = noone;

    if (instance_exists(obj_sdash)) {
        _sdash_inst = instance_find(obj_sdash, 0);
    } else {
        _sdash_inst = instance_create_layer(0, 0, "Instances", obj_sdash);
        show_debug_message("[LOAD] Sdash recriado.");
    }

    _sdash_inst.vida = _temp_vida;
    _sdash_inst.max_vida = _temp_max_vida;
    _sdash_inst.active = true;
    _sdash_inst.image_xscale = 0.78125;
    _sdash_inst.image_yscale = 0.78125;

    global.pause = false;
    global.pause_por_inventario = false;

    gc_game_state_sync_from_legacy();

    if (room != _temp_room) {
        var _trans = instance_create_layer(0, 0, "Instances", obj_transition);
        _trans.target_room = _temp_room;
        _trans.target_x = _temp_x;
        _trans.target_y = _temp_y;
    } else {
        _sdash_inst.x = _temp_x;
        _sdash_inst.y = _temp_y;
        gc_game_state_touch_room();
    }

    show_debug_message("[LOAD] Load concluido.");
    return true;
};

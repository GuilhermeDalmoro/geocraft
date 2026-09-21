/// @description Estado central e serializavel da campanha do Geocraft.

function gc_global_default(_name, _value) {
    if (!variable_global_exists(_name)) variable_global_set(_name, _value);
    return variable_global_get(_name);
}

function gc_game_state_defaults() {
    gc_global_default("pause", false);
    gc_global_default("pause_por_inventario", false);
    gc_global_default("dialogo_acontecendo", false);
    gc_global_default("modo_construcao", false);
    gc_global_default("tutorial", false);
    gc_global_default("moedas", 0);
    gc_global_default("inimigos_mortos", 0);
    gc_global_default("cabalos_alimentados", 0);
    gc_global_default("orbs", 0);
    gc_global_default("tem_magia", array_create(5, false));

    var _areas = array_create(6, false);
    for (var _i = 0; _i < 6; _i++) {
        _areas[_i] = gc_global_default("area_" + string(_i + 1), false);
    }

    var _rep = {};
    var _rep_names = [
        "maldade", "bondade", "honestidade", "egoismo",
        "fama", "temido", "respeito", "caridade",
        "lealdade", "rancor", "caos", "ordem",
        "riqueza", "arrogancia", "empatia", "ambicao"
    ];

    for (var _r = 0; _r < array_length(_rep_names); _r++) {
        var _name = _rep_names[_r];
        variable_struct_set(_rep, _name, gc_global_default(_name, 0));
    }

    return {
        schema_version : 4,

        runtime : {
            pause : global.pause,
            pause_por_inventario : global.pause_por_inventario,
            dialogo_acontecendo : global.dialogo_acontecendo,
            modo_construcao : global.modo_construcao,
            dev_mode : false,
            quest_journal_open : false,
            debug_open : false,
            toast_text : "",
            toast_timer : 0,
            toast_queue : [],
            tracked_quest_id : ""
        },

        campaign : {
            chapter : 1,
            stage : "inicio",
            flags : {},
            counters : {
                inimigos_mortos : global.inimigos_mortos,
                cabalos_alimentados : global.cabalos_alimentados,
                orbs : global.orbs
            },
            economy : {
                moedas : global.moedas
            },
            unlocks : {
                tutorial : global.tutorial,
                tem_magia : global.tem_magia
            },
            areas : _areas,
            reputation : _rep
        },

        world : {
            last_room : room_get_name(room),
            visited_rooms : [room_get_name(room)],
            placed_structures : [],
            furnaces : []
        },

        missions : scr_missoes_banco()
    };
}

function gc_game_state_bootstrap() {
    if (!variable_global_exists("game_state") || !is_struct(global.game_state)) {
        global.game_state = gc_game_state_defaults();
    }

    global.missoes = global.game_state.missions;
    gc_game_state_sync_to_legacy();
    return global.game_state;
}

function gc_game_state_sync_from_legacy() {
    if (!variable_global_exists("game_state") || !is_struct(global.game_state)) {
        return gc_game_state_bootstrap();
    }

    var _s = global.game_state;

    _s.runtime.pause = gc_global_default("pause", false);
    _s.runtime.pause_por_inventario = gc_global_default("pause_por_inventario", false);
    _s.runtime.dialogo_acontecendo = gc_global_default("dialogo_acontecendo", false);
    _s.runtime.modo_construcao = gc_global_default("modo_construcao", false);

    _s.campaign.counters.inimigos_mortos = gc_global_default("inimigos_mortos", 0);
    _s.campaign.counters.cabalos_alimentados = gc_global_default("cabalos_alimentados", 0);
    _s.campaign.counters.orbs = gc_global_default("orbs", 0);
    _s.campaign.economy.moedas = gc_global_default("moedas", 0);
    _s.campaign.unlocks.tutorial = gc_global_default("tutorial", false);
    _s.campaign.unlocks.tem_magia = gc_global_default("tem_magia", array_create(5, false));

    for (var _i = 0; _i < 6; _i++) {
        _s.campaign.areas[_i] = gc_global_default("area_" + string(_i + 1), false);
    }

    var _rep_names = [
        "maldade", "bondade", "honestidade", "egoismo",
        "fama", "temido", "respeito", "caridade",
        "lealdade", "rancor", "caos", "ordem",
        "riqueza", "arrogancia", "empatia", "ambicao"
    ];

    for (var _r = 0; _r < array_length(_rep_names); _r++) {
        var _name = _rep_names[_r];
        variable_struct_set(_s.campaign.reputation, _name, gc_global_default(_name, 0));
    }

    if (variable_global_exists("missoes") && is_array(global.missoes)) {
        _s.missions = global.missoes;
    }

    return _s;
}

function gc_game_state_sync_to_legacy() {
    if (!variable_global_exists("game_state") || !is_struct(global.game_state)) return false;

    var _s = global.game_state;

    global.pause = _s.runtime.pause;
    global.pause_por_inventario = _s.runtime.pause_por_inventario;
    global.dialogo_acontecendo = _s.runtime.dialogo_acontecendo;
    global.modo_construcao = _s.runtime.modo_construcao;

    global.inimigos_mortos = _s.campaign.counters.inimigos_mortos;
    global.cabalos_alimentados = _s.campaign.counters.cabalos_alimentados;
    global.orbs = _s.campaign.counters.orbs;
    global.moedas = _s.campaign.economy.moedas;
    global.tutorial = _s.campaign.unlocks.tutorial;
    global.tem_magia = _s.campaign.unlocks.tem_magia;

    for (var _i = 0; _i < 6; _i++) {
        variable_global_set("area_" + string(_i + 1), _s.campaign.areas[_i]);
    }

    var _rep_names = [
        "maldade", "bondade", "honestidade", "egoismo",
        "fama", "temido", "respeito", "caridade",
        "lealdade", "rancor", "caos", "ordem",
        "riqueza", "arrogancia", "empatia", "ambicao"
    ];

    for (var _r = 0; _r < array_length(_rep_names); _r++) {
        var _name = _rep_names[_r];
        variable_global_set(_name, variable_struct_get(_s.campaign.reputation, _name));
    }

    global.missoes = _s.missions;
    return true;
}

function gc_state_flag_get(_name, _default = false) {
    gc_game_state_bootstrap();
    if (!variable_struct_exists(global.game_state.campaign.flags, _name)) {
        variable_struct_set(global.game_state.campaign.flags, _name, _default);
    }
    return variable_struct_get(global.game_state.campaign.flags, _name);
}

function gc_state_flag_set(_name, _value) {
    gc_game_state_bootstrap();
    variable_struct_set(global.game_state.campaign.flags, _name, _value);
    return _value;
}

function gc_state_counter_get(_name, _default = 0) {
    gc_game_state_bootstrap();
    if (!variable_struct_exists(global.game_state.campaign.counters, _name)) {
        variable_struct_set(global.game_state.campaign.counters, _name, _default);
    }
    return variable_struct_get(global.game_state.campaign.counters, _name);
}

function gc_state_counter_set(_name, _value) {
    gc_game_state_bootstrap();
    variable_struct_set(global.game_state.campaign.counters, _name, _value);
    if (variable_global_exists(_name)) variable_global_set(_name, _value);
    return _value;
}

function gc_state_counter_add(_name, _amount = 1) {
    return gc_state_counter_set(_name, gc_state_counter_get(_name, 0) + _amount);
}

function gc_state_reputation_add(_name, _amount) {
    gc_game_state_bootstrap();
    var _rep = global.game_state.campaign.reputation;
    if (!variable_struct_exists(_rep, _name)) variable_struct_set(_rep, _name, 0);
    var _value = variable_struct_get(_rep, _name) + _amount;
    variable_struct_set(_rep, _name, _value);
    variable_global_set(_name, _value);
    return _value;
}

function gc_state_area_set(_area, _unlocked = true) {
    gc_game_state_bootstrap();
    var _i = clamp(_area - 1, 0, 5);
    global.game_state.campaign.areas[_i] = _unlocked;
    variable_global_set("area_" + string(_i + 1), _unlocked);
    return _unlocked;
}

function gc_state_magic_set(_slot, _unlocked = true) {
    gc_game_state_bootstrap();
    if (!is_array(global.game_state.campaign.unlocks.tem_magia)) {
        global.game_state.campaign.unlocks.tem_magia = array_create(5, false);
    }
    var _i = clamp(_slot, 0, array_length(global.game_state.campaign.unlocks.tem_magia) - 1);
    global.game_state.campaign.unlocks.tem_magia[_i] = _unlocked;
    global.tem_magia = global.game_state.campaign.unlocks.tem_magia;
    return _unlocked;
}

function gc_world_room_entered(_room_name) {
    gc_game_state_bootstrap();
    global.game_state.world.last_room = _room_name;

    var _visited = global.game_state.world.visited_rooms;
    var _found = false;
    for (var _i = 0; _i < array_length(_visited); _i++) {
        if (_visited[_i] == _room_name) { _found = true; break; }
    }
    if (!_found) array_push(global.game_state.world.visited_rooms, _room_name);
}

function gc_world_structure_add(_kind, _room_name, _x, _y) {
    gc_game_state_bootstrap();

    var _list = global.game_state.world.placed_structures;

    for (var _i = 0; _i < array_length(_list); _i++) {
        var _s = _list[_i];
        if (_s.kind == _kind
        && _s.room_name == _room_name
        && point_distance(_s.x, _s.y, _x, _y) < 4) {
            return false;
        }
    }

    array_push(global.game_state.world.placed_structures, {
        kind : _kind,
        room_name : _room_name,
        x : _x,
        y : _y
    });

    if (_kind == "fornalha") {
        gc_world_furnace_get(_room_name, _x, _y, true);
    }

    return true;
}

function gc_world_furnace_get(_room_name, _x, _y, _create = true) {
    gc_game_state_bootstrap();

    if (!variable_struct_exists(global.game_state.world, "furnaces")
    || !is_array(global.game_state.world.furnaces)) {
        global.game_state.world.furnaces = [];
    }

    var _list = global.game_state.world.furnaces;

    for (var _i = 0; _i < array_length(_list); _i++) {
        var _f = _list[_i];

        if (!is_struct(_f)) continue;

        if (_f.room_name == _room_name
        && point_distance(_f.x, _f.y, _x, _y) < 4) {
            return _f;
        }
    }

    if (!_create) return noone;

    var _new = {
        room_name : _room_name,
        x : _x,
        y : _y,
        active : false,
        recipe_id : -1,
        progress : 0,
        duration : 0,
        output_id : -1,
        output_qty : 0,
        total_batches : 0
    };

    array_push(global.game_state.world.furnaces, _new);
    return _new;
}

function gc_world_furnace_remove(_room_name, _x, _y) {
    gc_game_state_bootstrap();

    if (!variable_struct_exists(global.game_state.world, "furnaces")
    || !is_array(global.game_state.world.furnaces)) return false;

    var _list = global.game_state.world.furnaces;

    for (var _i = array_length(_list) - 1; _i >= 0; _i--) {
        var _f = _list[_i];

        if (is_struct(_f)
        && _f.room_name == _room_name
        && point_distance(_f.x, _f.y, _x, _y) < 4) {
            array_delete(_list, _i, 1);
            return true;
        }
    }

    return false;
}

function gc_game_state_new_run() {
    // Reset explicito. Diferente de defaults(), nao reaproveita globals antigos.
    global.pause = false;
    global.pause_por_inventario = false;
    global.dialogo_acontecendo = false;
    global.modo_construcao = false;

    global.tutorial = false;
    global.moedas = 0;
    global.inimigos_mortos = 0;
    global.cabalos_alimentados = 0;
    global.orbs = 0;
    global.minions_mortos = 0;

    global.tem_magia = array_create(5, false);
    global.magia_selecionada = 0;
    global.item_player = noone;

    for (var _a = 1; _a <= 6; _a++) {
        variable_global_set("area_" + string(_a), false);
    }

    var _rep_names = [
        "maldade", "bondade", "honestidade", "egoismo",
        "fama", "temido", "respeito", "caridade",
        "lealdade", "rancor", "caos", "ordem",
        "riqueza", "arrogancia", "empatia", "ambicao"
    ];

    for (var _r = 0; _r < array_length(_rep_names); _r++) {
        variable_global_set(_rep_names[_r], 0);
    }

    global.game_state = gc_game_state_defaults();
    global.missoes = global.game_state.missions;

    if (variable_global_exists("inventario_slots")
    && ds_exists(global.inventario_slots, ds_type_grid)) {
        ds_grid_clear(global.inventario_slots, 0);
    }

    return global.game_state;
}

function gc_world_structure_exists_here(_kind, _x, _y) {
    switch (_kind) {
        case "fornalha":
            for (var _i = 0; _i < instance_number(obj_fornalha); _i++) {
                var _inst = instance_find(obj_fornalha, _i);
                if (_inst != noone && point_distance(_inst.x, _inst.y, _x, _y) < 4) return true;
            }
        break;
    }

    return false;
}

function gc_world_restore_room(_room_name) {
    gc_game_state_bootstrap();

    var _list = global.game_state.world.placed_structures;

    for (var _i = 0; _i < array_length(_list); _i++) {
        var _s = _list[_i];

        if (!is_struct(_s)) continue;
        if (_s.room_name != _room_name) continue;
        if (gc_world_structure_exists_here(_s.kind, _s.x, _s.y)) continue;

        switch (_s.kind) {
            case "fornalha":
                instance_create_depth(_s.x, _s.y, -_s.y, obj_fornalha);
            break;
        }
    }

    // Depois de load, instancias que ja existiam na room precisam apontar
    // para os structs do GameState recem-importado.
    for (var _fi = 0; _fi < instance_number(obj_fornalha); _fi++) {
        var _furnace_inst = instance_find(obj_fornalha, _fi);

        if (_furnace_inst != noone) {
            _furnace_inst.fornalha_state = gc_world_furnace_get(
                _room_name,
                _furnace_inst.x,
                _furnace_inst.y,
                true
            );
        }
    }
}

function gc_game_state_export() {
    gc_game_state_sync_from_legacy();
    return {
        schema_version : global.game_state.schema_version,
        campaign : global.game_state.campaign,
        world : global.game_state.world,
        missions : gc_quest_export()
    };
}

function gc_game_state_import(_data) {
    var _new = gc_game_state_defaults();

    if (!is_struct(_data)) {
        global.game_state = _new;
        gc_game_state_sync_to_legacy();
        return false;
    }

    if (variable_struct_exists(_data, "campaign") && is_struct(_data.campaign)) {
        var _c = _data.campaign;
        if (variable_struct_exists(_c, "chapter")) _new.campaign.chapter = _c.chapter;
        if (variable_struct_exists(_c, "stage")) _new.campaign.stage = _c.stage;
        if (variable_struct_exists(_c, "flags") && is_struct(_c.flags)) _new.campaign.flags = _c.flags;
        if (variable_struct_exists(_c, "counters") && is_struct(_c.counters)) _new.campaign.counters = _c.counters;
        if (variable_struct_exists(_c, "economy") && is_struct(_c.economy)) _new.campaign.economy = _c.economy;
        if (variable_struct_exists(_c, "unlocks") && is_struct(_c.unlocks)) _new.campaign.unlocks = _c.unlocks;
        if (variable_struct_exists(_c, "areas") && is_array(_c.areas)) _new.campaign.areas = _c.areas;
        if (variable_struct_exists(_c, "reputation") && is_struct(_c.reputation)) _new.campaign.reputation = _c.reputation;
    }

    if (variable_struct_exists(_data, "world") && is_struct(_data.world)) {
        if (variable_struct_exists(_data.world, "last_room")) _new.world.last_room = _data.world.last_room;
        if (variable_struct_exists(_data.world, "visited_rooms") && is_array(_data.world.visited_rooms)) {
            _new.world.visited_rooms = _data.world.visited_rooms;
        }
        if (variable_struct_exists(_data.world, "placed_structures") && is_array(_data.world.placed_structures)) {
            _new.world.placed_structures = _data.world.placed_structures;
        }
        if (variable_struct_exists(_data.world, "furnaces") && is_array(_data.world.furnaces)) {
            _new.world.furnaces = _data.world.furnaces;
        }
    }

    // Normaliza saves antigos que tratavam magia como booleano.
    if (!is_array(_new.campaign.unlocks.tem_magia)) {
        _new.campaign.unlocks.tem_magia = array_create(5, false);
    }

    global.game_state = _new;
    global.missoes = _new.missions;

    if (variable_struct_exists(_data, "missions") && is_array(_data.missions)) {
        gc_quest_import(_data.missions);
    }

    gc_game_state_sync_to_legacy();
    return true;
}

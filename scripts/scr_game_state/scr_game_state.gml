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
        schema_version : 2,

        runtime : {
            pause : global.pause,
            pause_por_inventario : global.pause_por_inventario,
            dialogo_acontecendo : global.dialogo_acontecendo,
            modo_construcao : global.modo_construcao,
            dev_mode : false,
            quest_journal_open : false,
            debug_open : false,
            toast_text : "",
            toast_timer : 0
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
            visited_rooms : [room_get_name(room)]
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

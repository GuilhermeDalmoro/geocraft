/// @description Estado central da campanha do Geocraft.
/// Mantem compatibilidade com os global.* antigos enquanto novos sistemas migram
/// gradualmente para uma unica fonte de verdade.

function gc_global_ensure(_name, _default_value) {
    if (!variable_global_exists(_name)) {
        variable_global_set(_name, _default_value);
    }
    return variable_global_get(_name);
}

function gc_game_state_make_defaults() {
    // Garante que codigo legado que ainda depende destes globals continue vivo.
    gc_global_ensure("pause", false);
    gc_global_ensure("pause_por_inventario", false);
    gc_global_ensure("dialogo_acontecendo", false);
    gc_global_ensure("modo_construcao", false);
    gc_global_ensure("tutorial", true);
    gc_global_ensure("tem_magia", array_create(5, false));
    gc_global_ensure("moedas", 0);
    gc_global_ensure("inimigos_mortos", 0);
    gc_global_ensure("cabalos_alimentados", 0);
    gc_global_ensure("orbs", 0);

    var _areas = array_create(6, false);
    for (var _i = 0; _i < 6; _i++) {
        _areas[_i] = gc_global_ensure("area_" + string(_i + 1), false);
    }

    var _reputacao = {
        maldade      : gc_global_ensure("maldade", 0),
        bondade      : gc_global_ensure("bondade", 0),
        honestidade  : gc_global_ensure("honestidade", 0),
        egoismo      : gc_global_ensure("egoismo", 0),
        fama         : gc_global_ensure("fama", 0),
        temido       : gc_global_ensure("temido", 0),
        respeito     : gc_global_ensure("respeito", 0),
        caridade     : gc_global_ensure("caridade", 0),
        lealdade     : gc_global_ensure("lealdade", 0),
        rancor       : gc_global_ensure("rancor", 0),
        caos         : gc_global_ensure("caos", 0),
        ordem        : gc_global_ensure("ordem", 0),
        riqueza      : gc_global_ensure("riqueza", 0),
        arrogancia   : gc_global_ensure("arrogancia", 0),
        empatia      : gc_global_ensure("empatia", 0),
        ambicao      : gc_global_ensure("ambicao", 0)
    };

    return {
        schema_version : 1,

        runtime : {
            pause                 : global.pause,
            pause_por_inventario  : global.pause_por_inventario,
            dialogo_acontecendo   : global.dialogo_acontecendo,
            modo_construcao       : global.modo_construcao
        },

        campaign : {
            chapter : 1,
            stage   : "inicio",

            flags : {},

            counters : {
                inimigos_mortos     : global.inimigos_mortos,
                cabalos_alimentados : global.cabalos_alimentados,
                orbs                : global.orbs
            },

            economy : {
                moedas : global.moedas
            },

            unlocks : {
                tutorial : global.tutorial,
                tem_magia : global.tem_magia
            },

            areas : _areas,
            reputation : _reputacao
        },

        world : {
            last_room : room_get_name(room)
        },

        // Definicoes/estado atual das missoes. O array global.missoes continua
        // apontando para os mesmos structs para nao quebrar o codigo existente.
        missions : scr_missoes_banco()
    };
}

function gc_game_state_bootstrap() {
    if (!variable_global_exists("game_state") || !is_struct(global.game_state)) {
        global.game_state = gc_game_state_make_defaults();
    }

    gc_game_state_sync_to_legacy();
    return global.game_state;
}

function gc_game_state_sync_from_legacy() {
    if (!variable_global_exists("game_state") || !is_struct(global.game_state)) {
        return gc_game_state_bootstrap();
    }

    var _s = global.game_state;

    _s.runtime.pause                = gc_global_ensure("pause", false);
    _s.runtime.pause_por_inventario = gc_global_ensure("pause_por_inventario", false);
    _s.runtime.dialogo_acontecendo  = gc_global_ensure("dialogo_acontecendo", false);
    _s.runtime.modo_construcao      = gc_global_ensure("modo_construcao", false);

    _s.campaign.counters.inimigos_mortos     = gc_global_ensure("inimigos_mortos", 0);
    _s.campaign.counters.cabalos_alimentados = gc_global_ensure("cabalos_alimentados", 0);
    _s.campaign.counters.orbs                = gc_global_ensure("orbs", 0);
    _s.campaign.economy.moedas               = gc_global_ensure("moedas", 0);

    _s.campaign.unlocks.tutorial  = gc_global_ensure("tutorial", true);
    _s.campaign.unlocks.tem_magia = gc_global_ensure("tem_magia", array_create(5, false));

    for (var _i = 0; _i < 6; _i++) {
        _s.campaign.areas[_i] = gc_global_ensure("area_" + string(_i + 1), false);
    }

    var _rep_names = [
        "maldade", "bondade", "honestidade", "egoismo",
        "fama", "temido", "respeito", "caridade",
        "lealdade", "rancor", "caos", "ordem",
        "riqueza", "arrogancia", "empatia", "ambicao"
    ];

    for (var _r = 0; _r < array_length(_rep_names); _r++) {
        var _name = _rep_names[_r];
        variable_struct_set(_s.campaign.reputation, _name, gc_global_ensure(_name, 0));
    }

    if (variable_global_exists("missoes") && is_array(global.missoes)) {
        _s.missions = global.missoes;
    }

    _s.world.last_room = room_get_name(room);
    return _s;
}

function gc_game_state_sync_to_legacy() {
    if (!variable_global_exists("game_state") || !is_struct(global.game_state)) {
        return false;
    }

    var _s = global.game_state;

    global.pause                = _s.runtime.pause;
    global.pause_por_inventario = _s.runtime.pause_por_inventario;
    global.dialogo_acontecendo  = _s.runtime.dialogo_acontecendo;
    global.modo_construcao      = _s.runtime.modo_construcao;

    global.inimigos_mortos     = _s.campaign.counters.inimigos_mortos;
    global.cabalos_alimentados = _s.campaign.counters.cabalos_alimentados;
    global.orbs                = _s.campaign.counters.orbs;
    global.moedas              = _s.campaign.economy.moedas;

    global.tutorial  = _s.campaign.unlocks.tutorial;
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

function gc_game_state_touch_room() {
    if (!variable_global_exists("game_state") || !is_struct(global.game_state)) {
        gc_game_state_bootstrap();
    }
    global.game_state.world.last_room = room_get_name(room);
}

function gc_state_flag_get(_name, _default_value = false) {
    gc_game_state_bootstrap();

    if (!variable_struct_exists(global.game_state.campaign.flags, _name)) {
        variable_struct_set(global.game_state.campaign.flags, _name, _default_value);
    }

    return variable_struct_get(global.game_state.campaign.flags, _name);
}

function gc_state_flag_set(_name, _value) {
    gc_game_state_bootstrap();
    variable_struct_set(global.game_state.campaign.flags, _name, _value);
    return _value;
}

function gc_state_counter_get(_name, _default_value = 0) {
    gc_game_state_bootstrap();

    if (!variable_struct_exists(global.game_state.campaign.counters, _name)) {
        variable_struct_set(global.game_state.campaign.counters, _name, _default_value);
    }

    return variable_struct_get(global.game_state.campaign.counters, _name);
}

function gc_state_counter_set(_name, _value) {
    gc_game_state_bootstrap();
    variable_struct_set(global.game_state.campaign.counters, _name, _value);

    // Espelha automaticamente se ja existir um global legado de mesmo nome.
    if (variable_global_exists(_name)) {
        variable_global_set(_name, _value);
    }

    return _value;
}

function gc_state_counter_add(_name, _amount = 1) {
    return gc_state_counter_set(_name, gc_state_counter_get(_name, 0) + _amount);
}

function gc_state_reputation_add(_name, _amount) {
    gc_game_state_bootstrap();

    if (!variable_struct_exists(global.game_state.campaign.reputation, _name)) {
        variable_struct_set(global.game_state.campaign.reputation, _name, 0);
    }

    var _value = variable_struct_get(global.game_state.campaign.reputation, _name) + _amount;
    variable_struct_set(global.game_state.campaign.reputation, _name, _value);

    if (variable_global_exists(_name)) {
        variable_global_set(_name, _value);
    }

    return _value;
}

function gc_state_area_set(_area_index, _unlocked = true) {
    gc_game_state_bootstrap();

    var _index = clamp(_area_index - 1, 0, array_length(global.game_state.campaign.areas) - 1);
    global.game_state.campaign.areas[_index] = _unlocked;
    variable_global_set("area_" + string(_index + 1), _unlocked);

    return _unlocked;
}

function gc_state_magic_set(_slot, _unlocked = true) {
    gc_game_state_bootstrap();

    if (!is_array(global.game_state.campaign.unlocks.tem_magia)) {
        global.game_state.campaign.unlocks.tem_magia = array_create(5, false);
    }

    var _index = clamp(_slot, 0, array_length(global.game_state.campaign.unlocks.tem_magia) - 1);
    global.game_state.campaign.unlocks.tem_magia[_index] = _unlocked;

    if (!is_array(global.tem_magia)) {
        global.tem_magia = array_create(5, false);
    }
    global.tem_magia[_index] = _unlocked;

    return _unlocked;
}

function gc_game_state_export() {
    gc_game_state_sync_from_legacy();

    var _s = global.game_state;
    var _mission_state = [];

    for (var _i = 0; _i < array_length(_s.missions); _i++) {
        var _m = _s.missions[_i];
        if (is_struct(_m) && variable_struct_exists(_m, "id_m")) {
            array_push(_mission_state, {
                id_m : _m.id_m,
                status : variable_struct_exists(_m, "status") ? _m.status : "bloqueada"
            });
        }
    }

    return {
        schema_version : _s.schema_version,
        campaign : {
            chapter : _s.campaign.chapter,
            stage : _s.campaign.stage,
            flags : _s.campaign.flags,
            counters : _s.campaign.counters,
            economy : _s.campaign.economy,
            unlocks : _s.campaign.unlocks,
            areas : _s.campaign.areas,
            reputation : _s.campaign.reputation
        },
        world : {
            last_room : _s.world.last_room
        },
        missions : _mission_state
    };
}

function gc_game_state_import(_data) {
    var _new_state = gc_game_state_make_defaults();

    if (!is_struct(_data)) {
        global.game_state = _new_state;
        gc_game_state_sync_to_legacy();
        return false;
    }

    if (variable_struct_exists(_data, "campaign") && is_struct(_data.campaign)) {
        var _c = _data.campaign;

        if (variable_struct_exists(_c, "chapter")) _new_state.campaign.chapter = _c.chapter;
        if (variable_struct_exists(_c, "stage")) _new_state.campaign.stage = _c.stage;
        if (variable_struct_exists(_c, "flags") && is_struct(_c.flags)) _new_state.campaign.flags = _c.flags;
        if (variable_struct_exists(_c, "counters") && is_struct(_c.counters)) _new_state.campaign.counters = _c.counters;
        if (variable_struct_exists(_c, "economy") && is_struct(_c.economy)) _new_state.campaign.economy = _c.economy;
        if (variable_struct_exists(_c, "unlocks") && is_struct(_c.unlocks)) _new_state.campaign.unlocks = _c.unlocks;
        if (variable_struct_exists(_c, "areas") && is_array(_c.areas)) _new_state.campaign.areas = _c.areas;
        if (variable_struct_exists(_c, "reputation") && is_struct(_c.reputation)) _new_state.campaign.reputation = _c.reputation;
    }

    if (variable_struct_exists(_data, "world") && is_struct(_data.world)) {
        if (variable_struct_exists(_data.world, "last_room")) {
            _new_state.world.last_room = _data.world.last_room;
        }
    }

    if (variable_struct_exists(_data, "missions") && is_array(_data.missions)) {
        for (var _saved_i = 0; _saved_i < array_length(_data.missions); _saved_i++) {
            var _saved = _data.missions[_saved_i];
            if (!is_struct(_saved) || !variable_struct_exists(_saved, "id_m")) continue;

            for (var _mission_i = 0; _mission_i < array_length(_new_state.missions); _mission_i++) {
                var _mission = _new_state.missions[_mission_i];
                if (_mission.id_m == _saved.id_m) {
                    if (variable_struct_exists(_saved, "status")) {
                        _mission.status = _saved.status;
                    }
                    break;
                }
            }
        }
    }

    global.game_state = _new_state;
    gc_game_state_sync_to_legacy();
    return true;
}

function gc_game_state_debug_print() {
    gc_game_state_bootstrap();
    show_debug_message("=== GEOCRAFT GAME STATE ===");
    show_debug_message("schema: " + string(global.game_state.schema_version));
    show_debug_message("chapter: " + string(global.game_state.campaign.chapter));
    show_debug_message("stage: " + string(global.game_state.campaign.stage));
    show_debug_message("room: " + global.game_state.world.last_room);
    show_debug_message("moedas: " + string(global.game_state.campaign.economy.moedas));
    show_debug_message("===========================");
}

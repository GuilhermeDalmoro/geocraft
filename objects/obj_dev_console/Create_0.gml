/// DEV CONSOLE - ferramenta interativa de desenvolvimento do Geocraft.

if (instance_number(obj_dev_console) > 1) {
    instance_destroy();
    exit;
}

gc_game_state_bootstrap();

previous_pause = global.pause;

global.pause = true;
global.game_state.runtime.pause = true;
global.game_state.runtime.dev_mode = true;
global.game_state.runtime.modal_ui = "dev_console";

tab = 0;
row = 0;

quest_index = 0;
quest_objective_index = 0;
item_index = 0;
state_mode = 0; // 0 flags, 1 reputacao, 2 areas
state_index = 0;
world_mode = 0; // 0 rooms, 1 spawns
world_index = 0;
save_slot_dev = variable_global_exists("save_slot") ? global.save_slot : 1;
save_action = 0;

console_typing = false;
console_buffer = "";
console_log = [
    "DEV Console pronto.",
    "Abra a aba CONSOLE e digite 'help' para comandos avancados."
];

tab_names = [
    "RESUMO",
    "PLAYER",
    "CAMPANHA",
    "MISSOES",
    "INVENTARIO",
    "ESTADO",
    "MUNDO",
    "SAVES",
    "CONSOLE"
];

rep_names = [
    "maldade", "bondade", "honestidade", "egoismo",
    "fama", "temido", "respeito", "caridade",
    "lealdade", "rancor", "caos", "ordem",
    "riqueza", "arrogancia", "empatia", "ambicao"
];

stage_names = [
    "inicio",
    "m2_cavalos",
    "m3_viagem",
    "m4_cidadaos",
    "m5_exploracao",
    "pos_m5"
];

room_names = [
    "Room_logo",
    "room_menu",
    "Room1",
    "Room2",
    "Room3",
    "Room4_secret",
    "Room5",
    "Room6",
    "Room7_cutscene",
    "Room_intro",
    "Room_skill_tree",
    "Room_skill_tree_pag_2",
    "Room_game_over",
    "Room_menu_pause",
    "rm_casa1",
    "rm_creditos",
    "Room_shop1",
    "Room_sala1_pref",
    "room_menu_mundos",
    "Room_quarto_sdash",
    "Room_intermediario",
    "Room_pc",
    "Room_batalha_padrao",
    "Room_dentro_masmorra",
    "Room_dentro_masmorra_2"
];

spawn_names = [
    "obj_gmd",
    "obj_npc_proc",
    "obj_mineravel",
    "obj_moeda",
    "obj_drop",
    "obj_fornalha",
    "obj_teste_monstro"
];

dev_log_push = function(_text) {
    array_push(console_log, string(_text));

    while (array_length(console_log) > 9) {
        array_delete(console_log, 0, 1);
    }
};

dev_parse_value = function(_text) {
    var _s = string(_text);
    var _lower = string_lower(_s);

    if (_lower == "true") return true;
    if (_lower == "false") return false;
    if (_lower == "noone") return noone;

    if (string_length(_s) >= 2
    && string_char_at(_s, 1) == """
    && string_char_at(_s, string_length(_s)) == """) {
        return string_copy(_s, 2, string_length(_s) - 2);
    }

    var _numeric = (string_length(_s) > 0);
    var _dot_found = false;

    for (var _i = 1; _i <= string_length(_s); _i++) {
        var _ch = string_char_at(_s, _i);

        if (_ch == "-" && _i == 1) continue;

        if (_ch == "." && !_dot_found) {
            _dot_found = true;
            continue;
        }

        if (string_pos(_ch, "0123456789") <= 0) {
            _numeric = false;
            break;
        }
    }

    if (_numeric) return real(_s);

    return _s;
};

dev_exec_command = function(_command) {
    var _clean = string(_command);

    if (string_length(_clean) <= 0) return;

    dev_log_push("> " + _clean);

    var _parts = string_split(_clean, " ");

    if (array_length(_parts) <= 0) return;

    var _cmd = string_lower(_parts[0]);

    switch (_cmd) {
        case "help":
            dev_log_push("global NOME VALOR | player VAR VALOR");
            dev_log_push("instance OBJ VAR VALOR | spawn OBJ [QTD] | destroy OBJ");
            dev_log_push("flag NOME VALOR | counter NOME VALOR | rep NOME VALOR");
            dev_log_push("stage NOME | room ROOM | quest ID STATUS");
            dev_log_push("objective ID INDEX VALOR | give ITEM_ID QTD");
            dev_log_push("save N | load N | delete N | new N");
        break;

        case "global":
            if (array_length(_parts) >= 3) {
                var _name = _parts[1];
                var _value = dev_parse_value(_parts[2]);

                variable_global_set(_name, _value);
                gc_game_state_sync_from_legacy();

                dev_log_push("global." + _name + " = " + string(_value));
            }
        break;

        case "player":
            if (array_length(_parts) >= 3 && instance_exists(obj_sdash)) {
                var _p = instance_find(obj_sdash, 0);
                var _var = _parts[1];
                var _value = dev_parse_value(_parts[2]);

                variable_instance_set(_p, _var, _value);
                dev_log_push("Sdash." + _var + " = " + string(_value));
            }
            else {
                dev_log_push("Sdash nao existe.");
            }
        break;

        case "instance":
            if (array_length(_parts) >= 4) {
                var _asset = asset_get_index(_parts[1]);

                if (_asset == -1) {
                    dev_log_push("Asset nao encontrado: " + _parts[1]);
                }
                else {
                    var _var = _parts[2];
                    var _value = dev_parse_value(_parts[3]);
                    var _count = instance_number(_asset);

                    for (var _ii = 0; _ii < _count; _ii++) {
                        var _inst = instance_find(_asset, _ii);
                        if (_inst != noone) {
                            variable_instance_set(_inst, _var, _value);
                        }
                    }

                    dev_log_push(string(_count) + " instancia(s) alterada(s).");
                }
            }
        break;

        case "spawn":
            if (array_length(_parts) >= 2) {
                var _asset = asset_get_index(_parts[1]);
                var _qty = 1;

                if (array_length(_parts) >= 3) {
                    _qty = max(1, round(dev_parse_value(_parts[2])));
                }

                if (_asset == -1) {
                    dev_log_push("Asset nao encontrado: " + _parts[1]);
                }
                else {
                    var _sx = room_width * 0.5;
                    var _sy = room_height * 0.5;

                    if (instance_exists(obj_sdash)) {
                        var _p = instance_find(obj_sdash, 0);
                        _sx = _p.x;
                        _sy = _p.y;
                    }

                    repeat (_qty) {
                        instance_create_depth(
                            _sx + irandom_range(-32, 32),
                            _sy + irandom_range(-32, 32),
                            -_sy,
                            _asset
                        );
                    }

                    dev_log_push("Spawn: " + _parts[1] + " x" + string(_qty));
                }
            }
        break;

        case "destroy":
            if (array_length(_parts) >= 2) {
                var _asset = asset_get_index(_parts[1]);

                if (_asset != -1) {
                    var _count = instance_number(_asset);

                    with (_asset) {
                        instance_destroy();
                    }

                    dev_log_push("Destruidas " + string(_count) + " instancia(s).");
                }
            }
        break;

        case "flag":
            if (array_length(_parts) >= 3) {
                var _value = dev_parse_value(_parts[2]);
                gc_state_flag_set(_parts[1], _value);
                dev_log_push("flag " + _parts[1] + " = " + string(_value));
            }
        break;

        case "counter":
            if (array_length(_parts) >= 3) {
                var _value = dev_parse_value(_parts[2]);
                gc_state_counter_set(_parts[1], _value);
                dev_log_push("counter " + _parts[1] + " = " + string(_value));
            }
        break;

        case "rep":
            if (array_length(_parts) >= 3) {
                var _name = _parts[1];
                var _value = dev_parse_value(_parts[2]);

                variable_struct_set(
                    global.game_state.campaign.reputation,
                    _name,
                    _value
                );

                variable_global_set(_name, _value);
                dev_log_push("rep " + _name + " = " + string(_value));
            }
        break;

        case "stage":
            if (array_length(_parts) >= 2) {
                global.game_state.campaign.stage = _parts[1];
                dev_log_push("stage = " + _parts[1]);
            }
        break;

        case "room":
            if (array_length(_parts) >= 2) {
                var _room = asset_get_index(_parts[1]);

                if (_room == -1) {
                    dev_log_push("Room nao encontrada: " + _parts[1]);
                }
                else {
                    dev_log_push("Indo para " + _parts[1]);
                    room_goto(_room);
                }
            }
        break;

        case "quest":
            if (array_length(_parts) >= 3) {
                var _q = gc_quest_get(_parts[1]);

                if (_q == noone) {
                    dev_log_push("Missao nao encontrada.");
                }
                else {
                    var _status = string_lower(_parts[2]);

                    if (_status == "ativa") {
                        _q.status = "ativa";
                        gc_quest_track(_q.id_m);
                    }
                    else if (_status == "pronta") {
                        _q.status = "pronta";
                    }
                    else if (_status == "concluida") {
                        if (is_array(_q.objetivos)) {
                            for (var _oi = 0; _oi < array_length(_q.objetivos); _oi++) {
                                _q.objetivos[_oi].current = _q.objetivos[_oi].required;
                                _q.objetivos[_oi].complete = true;
                            }
                        }

                        _q.status = "pronta";
                        gc_quest_complete(_q.id_m);
                    }
                    else if (_status == "bloqueada") {
                        _q.status = "bloqueada";

                        if (is_array(_q.objetivos)) {
                            for (var _oi = 0; _oi < array_length(_q.objetivos); _oi++) {
                                _q.objetivos[_oi].current = 0;
                                _q.objetivos[_oi].complete = false;
                            }
                        }
                    }

                    dev_log_push(_q.id_m + " => " + _q.status);
                }
            }
        break;

        case "objective":
            if (array_length(_parts) >= 4) {
                var _q = gc_quest_get(_parts[1]);

                if (_q != noone && is_array(_q.objetivos)) {
                    var _index = round(dev_parse_value(_parts[2]));
                    var _value = round(dev_parse_value(_parts[3]));

                    if (_index >= 0 && _index < array_length(_q.objetivos)) {
                        var _o = _q.objetivos[_index];

                        _o.current = clamp(_value, 0, _o.required);
                        _o.complete = (_o.current >= _o.required);

                        dev_log_push(
                            _q.id_m + " objetivo "
                            + string(_index) + " = " + string(_o.current)
                        );
                    }
                }
            }
        break;

        case "give":
            if (array_length(_parts) >= 3) {
                var _id = round(dev_parse_value(_parts[1]));
                var _qty = max(1, round(dev_parse_value(_parts[2])));

                if (adiciona_ao_inventario(_id, _qty)) {
                    dev_log_push("Item " + string(_id) + " x" + string(_qty));
                }
                else {
                    dev_log_push("Nao foi possivel adicionar o item.");
                }
            }
        break;

        case "save":
            if (array_length(_parts) >= 2 && variable_global_exists("salva_jogo")) {
                global.salva_jogo(round(dev_parse_value(_parts[1])));
                dev_log_push("Save executado.");
            }
        break;

        case "load":
            if (array_length(_parts) >= 2 && variable_global_exists("carrega_jogo")) {
                global.carrega_jogo(round(dev_parse_value(_parts[1])));
                dev_log_push("Load executado.");
            }
        break;

        case "delete":
            if (array_length(_parts) >= 2 && variable_global_exists("delete_save_slot")) {
                global.delete_save_slot(round(dev_parse_value(_parts[1])));
                dev_log_push("Slot apagado.");
            }
        break;

        case "new":
            if (array_length(_parts) >= 2 && variable_global_exists("novo_jogo")) {
                global.novo_jogo(round(dev_parse_value(_parts[1])));
            }
        break;

        default:
            dev_log_push("Comando desconhecido. Use: help");
        break;
    }
};

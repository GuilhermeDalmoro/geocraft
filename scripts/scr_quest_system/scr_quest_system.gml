/// @description Quest System v3 - progresso orientado a eventos, tracking e encadeamento.

function gc_quest_objective(_type, _target, _required, _label) {
    return {
        type : _type,
        target : _target,
        required : max(1, _required),
        current : 0,
        complete : false,
        label : _label
    };
}

function gc_quest_make(
    _id,
    _name,
    _desc,
    _objectives,
    _rewards = [],
    _auto_complete = false,
    _hidden = false,
    _category = "principal",
    _giver = "",
    _order = 0,
    _requires = []
) {
    return {
        id_m : _id,
        nome : _name,
        descricao : _desc,
        status : "bloqueada",
        objetivos : _objectives,
        recompensas : _rewards,
        auto_complete : _auto_complete,
        hidden : _hidden,
        categoria : _category,
        responsavel : _giver,
        ordem : _order,
        requisitos : _requires
    };
}

function gc_quest_database() {
    return [
        gc_quest_make(
            "teste",
            "Missao de Teste",
            "Missao interna mantida para compatibilidade.",
            [],
            [],
            false,
            true,
            "debug",
            "",
            -100
        ),

        // M1 das notas de historia.
        gc_quest_make(
            "m001_almudeao",
            "Comunique o Almudeao",
            "Conte ao Almudeao o que aconteceu depois do contato com o dejeto.",
            [
                gc_quest_objective("falar", "Missao Cavalos", 1, "Fale com Almudeao")
            ],
            [
                { type : "moedas", amount : 10 },
                { type : "flag", name : "almudeao_informado" }
            ],
            true,
            false,
            "principal",
            "Almudeao",
            1
        ),

        // Tutorial de combate ja existente no prototipo.
        gc_quest_make(
            "treino_gmd",
            "Treino geometrico",
            "King of Art's quer ver se o cowboy cubico sabe se defender.",
            [
                gc_quest_objective("matar", "gmd", 9, "Derrote os GMDs")
            ],
            [
                { type : "moedas", amount : 25 }
            ],
            false,
            false,
            "tutorial",
            "King of Art's",
            2
        ),

        // M2.
        gc_quest_make(
            "alimentar_cavalos",
            "Cafe da manha quadrupede",
            "Ajude o Almudeao a alimentar os cavalos no estabulo.",
            [
                gc_quest_objective("alimentar", "cavalo", 4, "Alimente os cavalos")
            ],
            [
                { type : "moedas", amount : 20 },
                { type : "reputacao", name : "lealdade", amount : 1 }
            ],
            true,
            false,
            "principal",
            "Almudeao",
            3,
            ["m001_almudeao"]
        ),

        // M3.
        gc_quest_make(
            "viagem_cubicland",
            "Rumo a Cubic-Land",
            "Escolha um cavalo e siga viagem ate o centro de Cubic-Land.",
            [
                gc_quest_objective("montar", "cavalo", 1, "Monte em um cavalo"),
                gc_quest_objective("visitar", "Room6", 1, "Chegue ao centro de Cubic-Land")
            ],
            [
                { type : "moedas", amount : 30 },
                { type : "area", area : 2 }
            ],
            true,
            false,
            "principal",
            "Almudeao",
            4,
            ["alimentar_cavalos"]
        ),

        // M4 - usa de verdade inventario + coleta + construcao.
        gc_quest_make(
            "ajudar_cidadaos",
            "Mao na massa em Cubic-Land",
            "Ajude os cidadaos usando seu inventario: junte recursos e comece a reconstruir a cidade.",
            [
                gc_quest_objective("coletar", "*", 10, "Colete 10 recursos"),
                gc_quest_objective("construir", "fornalha", 1, "Construa uma fornalha")
            ],
            [
                { type : "moedas", amount : 50 },
                { type : "reputacao", name : "respeito", amount : 2 },
                { type : "flag", name : "reconstrucao_iniciada" }
            ],
            true,
            false,
            "principal",
            "Cidadaos de Cubic-Land",
            5,
            ["viagem_cubicland"]
        ),

        // M5.
        gc_quest_make(
            "explorar_cubicland",
            "Faxina geometrica",
            "Explore Cubic-Land e reduza a populacao de monstros hostis.",
            [
                gc_quest_objective("matar", "inimigo", 10, "Derrote monstros em Cubic-Land")
            ],
            [
                { type : "moedas", amount : 75 },
                { type : "magia", slot : 1, nome : "Agua" },
                { type : "flag", name : "magia_agua_descoberta" }
            ],
            true,
            false,
            "principal",
            "Cubic-Land",
            6,
            ["ajudar_cidadaos"]
        ),

        // Boss ja existente no projeto. Comeca ao entrar na sequencia dele.
        gc_quest_make(
            "andrius",
            "O guardiao Andrius",
            "Enfrente Andrius e sobreviva ao caos cubico.",
            [
                gc_quest_objective("matar", "andrius", 1, "Derrote Andrius")
            ],
            [
                { type : "moedas", amount : 100 },
                { type : "flag", name : "andrius_derrotado" }
            ],
            true,
            false,
            "boss",
            "",
            50
        )
    ];
}

function gc_quest_get(_id) {
    if (!variable_global_exists("missoes") || !is_array(global.missoes)) return noone;

    for (var _i = 0; _i < array_length(global.missoes); _i++) {
        var _q = global.missoes[_i];
        if (is_struct(_q)
        && variable_struct_exists(_q, "id_m")
        && _q.id_m == _id) {
            return _q;
        }
    }

    return noone;
}

function gc_quest_is_done(_id) {
    var _q = gc_quest_get(_id);
    return (_q != noone && _q.status == "concluida");
}

function gc_quest_requirements_met(_q) {
    if (!is_struct(_q)) return false;
    if (!variable_struct_exists(_q, "requisitos") || !is_array(_q.requisitos)) return true;

    for (var _i = 0; _i < array_length(_q.requisitos); _i++) {
        if (!gc_quest_is_done(_q.requisitos[_i])) return false;
    }

    return true;
}

function gc_quest_toast(_text, _frames = 180) {
    gc_game_state_bootstrap();

    var _runtime = global.game_state.runtime;

    if (!variable_struct_exists(_runtime, "toast_queue") || !is_array(_runtime.toast_queue)) {
        _runtime.toast_queue = [];
    }

    if (_runtime.toast_timer <= 0 || string_length(_runtime.toast_text) <= 0) {
        _runtime.toast_text = _text;
        _runtime.toast_timer = _frames;
    }
    else {
        array_push(_runtime.toast_queue, {
            text : _text,
            frames : _frames
        });
    }
}

function gc_quest_toast_step() {
    gc_game_state_bootstrap();

    var _runtime = global.game_state.runtime;

    if (_runtime.toast_timer > 0) {
        _runtime.toast_timer--;
        return;
    }

    if (!variable_struct_exists(_runtime, "toast_queue") || !is_array(_runtime.toast_queue)) {
        _runtime.toast_queue = [];
        return;
    }

    if (array_length(_runtime.toast_queue) <= 0) {
        _runtime.toast_text = "";
        return;
    }

    var _next = _runtime.toast_queue[0];
    array_delete(_runtime.toast_queue, 0, 1);

    _runtime.toast_text = _next.text;
    _runtime.toast_timer = _next.frames;
}

function gc_quest_set_stage(_stage) {
    gc_game_state_bootstrap();
    global.game_state.campaign.stage = _stage;
}

function gc_quest_inventory_count(_target) {
    if (!variable_global_exists("inventario_slots")) return 0;
    if (!ds_exists(global.inventario_slots, ds_type_grid)) return 0;

    var _count = 0;
    var _w = ds_grid_width(global.inventario_slots);
    var _h = ds_grid_height(global.inventario_slots);

    for (var _y = 0; _y < _h; _y++) {
        for (var _x = 0; _x < _w; _x++) {
            var _slot = global.inventario_slots[# _x, _y];
            if (!is_struct(_slot)) continue;

            var _matches = (_target == "*" || string(_slot.id) == string(_target));

            if (!_matches
            && variable_global_exists("itens")
            && ds_exists(global.itens, ds_type_list)
            && _slot.id >= 0
            && _slot.id < ds_list_size(global.itens)) {

                var _item = global.itens[| _slot.id];
                if (is_struct(_item)
                && variable_struct_exists(_item, "nome")
                && string(_item.nome) == string(_target)) {
                    _matches = true;
                }
            }

            if (_matches) _count += _slot.quantity;
        }
    }

    return _count;
}

function gc_quest_structure_count(_kind) {
    gc_game_state_bootstrap();

    var _count = 0;
    var _list = global.game_state.world.placed_structures;

    if (!is_array(_list)) return 0;

    for (var _i = 0; _i < array_length(_list); _i++) {
        var _s = _list[_i];
        if (is_struct(_s)
        && variable_struct_exists(_s, "kind")
        && _s.kind == _kind) {
            _count++;
        }
    }

    return _count;
}

function gc_quest_reconcile(_q) {
    if (!is_struct(_q)
    || !variable_struct_exists(_q, "objetivos")
    || !is_array(_q.objetivos)) return;

    gc_game_state_bootstrap();

    for (var _i = 0; _i < array_length(_q.objetivos); _i++) {
        var _o = _q.objetivos[_i];
        if (_o.complete) continue;

        switch (_o.type) {
            case "alimentar":
                if (_o.target == "cavalo") {
                    _o.current = max(_o.current, min(_o.required, global.cabalos_alimentados));
                }
            break;

            case "montar":
                if (_o.target == "cavalo" && instance_exists(obj_sdash)) {
                    var _s = instance_find(obj_sdash, 0);
                    if (variable_instance_exists(_s, "montado") && _s.montado) {
                        _o.current = _o.required;
                    }
                }
            break;

            case "visitar":
                var _visited = global.game_state.world.visited_rooms;
                if (is_array(_visited)) {
                    for (var _v = 0; _v < array_length(_visited); _v++) {
                        if (_visited[_v] == _o.target) {
                            _o.current = _o.required;
                            break;
                        }
                    }
                }
            break;

            case "coletar":
                _o.current = max(
                    _o.current,
                    min(_o.required, gc_quest_inventory_count(_o.target))
                );
            break;

            case "construir":
                _o.current = max(
                    _o.current,
                    min(_o.required, gc_quest_structure_count(_o.target))
                );
            break;
        }

        _o.complete = (_o.current >= _o.required);
    }
}

function gc_quest_track(_id) {
    gc_game_state_bootstrap();

    var _q = gc_quest_get(_id);
    if (_q == noone) return false;

    if (_q.status != "ativa" && _q.status != "pronta") return false;

    global.game_state.runtime.tracked_quest_id = _q.id_m;
    return true;
}

function gc_quest_get_visible() {
    var _out = [];

    if (!variable_global_exists("missoes") || !is_array(global.missoes)) return _out;

    for (var _i = 0; _i < array_length(global.missoes); _i++) {
        var _q = global.missoes[_i];

        if (!is_struct(_q)) continue;
        if (variable_struct_exists(_q, "hidden") && _q.hidden) continue;
        if (_q.status == "bloqueada") continue;

        array_push(_out, _q);
    }

    return _out;
}

function gc_quest_get_tracked() {
    if (!variable_global_exists("missoes") || !is_array(global.missoes)) return noone;

    gc_game_state_bootstrap();

    var _tracked_id = global.game_state.runtime.tracked_quest_id;

    if (string_length(string(_tracked_id)) > 0) {
        var _tracked = gc_quest_get(_tracked_id);

        if (_tracked != noone
        && (_tracked.status == "ativa" || _tracked.status == "pronta")) {
            return _tracked;
        }
    }

    for (var _i = 0; _i < array_length(global.missoes); _i++) {
        var _q = global.missoes[_i];
        if (!is_struct(_q)) continue;
        if (variable_struct_exists(_q, "hidden") && _q.hidden) continue;

        if (_q.status == "ativa" || _q.status == "pronta") {
            global.game_state.runtime.tracked_quest_id = _q.id_m;
            return _q;
        }
    }

    global.game_state.runtime.tracked_quest_id = "";
    return noone;
}

function gc_quest_start(_id) {
    gc_game_state_bootstrap();

    var _q = gc_quest_get(_id);

    if (_q == noone) {
        show_debug_message("[QUEST] Missao inexistente: " + string(_id));
        return false;
    }

    if (_q.status == "concluida"
    || _q.status == "ativa"
    || _q.status == "pronta") {
        return false;
    }

    if (!gc_quest_requirements_met(_q)) {
        show_debug_message("[QUEST] Requisitos nao cumpridos: " + _q.id_m);
        return false;
    }

    _q.status = "ativa";
    gc_quest_reconcile(_q);
    gc_quest_track(_q.id_m);

    gc_quest_toast("Nova missao: " + _q.nome, 220);
    show_debug_message("[QUEST] Iniciada: " + _q.id_m);

    if (gc_quest_all_objectives_complete(_q)) {
        _q.status = "pronta";
        gc_state_flag_set("quest_" + _q.id_m + "_objetivos", true);

        if (variable_struct_exists(_q, "auto_complete") && _q.auto_complete) {
            gc_quest_complete(_q.id_m);
        }
    }

    return true;
}

function gc_quest_all_objectives_complete(_q) {
    if (!is_struct(_q)
    || !variable_struct_exists(_q, "objetivos")
    || !is_array(_q.objetivos)
    || array_length(_q.objetivos) == 0) {
        return true;
    }

    for (var _i = 0; _i < array_length(_q.objetivos); _i++) {
        if (!_q.objetivos[_i].complete) return false;
    }

    return true;
}

function gc_quest_apply_rewards(_q) {
    if (!variable_struct_exists(_q, "recompensas") || !is_array(_q.recompensas)) return;

    for (var _i = 0; _i < array_length(_q.recompensas); _i++) {
        var _r = _q.recompensas[_i];
        if (!is_struct(_r) || !variable_struct_exists(_r, "type")) continue;

        switch (_r.type) {
            case "moedas":
                var _coins = variable_struct_exists(_r, "amount") ? _r.amount : 0;
                global.moedas += _coins;
                gc_game_state_sync_from_legacy();

                if (_coins > 0) {
                    gc_quest_toast("Recompensa: +" + string(_coins) + " moedas", 120);
                }
            break;

            case "item":
                if (variable_struct_exists(_r, "id")) {
                    var _qtd = variable_struct_exists(_r, "amount") ? _r.amount : 1;
                    adiciona_ao_inventario(_r.id, _qtd);
                }
            break;

            case "magia":
                if (variable_struct_exists(_r, "slot")) {
                    gc_state_magic_set(_r.slot, true);

                    var _magic_name = variable_struct_exists(_r, "nome")
                        ? _r.nome
                        : ("Slot " + string(_r.slot));

                    gc_quest_toast("Nova magia desbloqueada: " + _magic_name, 220);
                }
            break;

            case "area":
                if (variable_struct_exists(_r, "area")) {
                    gc_state_area_set(_r.area, true);
                }
            break;

            case "reputacao":
                if (variable_struct_exists(_r, "name")) {
                    var _rep_amount = variable_struct_exists(_r, "amount") ? _r.amount : 0;
                    gc_state_reputation_add(_r.name, _rep_amount);
                }
            break;

            case "flag":
                if (variable_struct_exists(_r, "name")) {
                    gc_state_flag_set(_r.name, true);
                }
            break;
        }
    }
}

function gc_quest_chain(_id) {
    switch (_id) {
        case "m001_almudeao":
            gc_quest_set_stage("m2_cavalos");
            gc_quest_start("alimentar_cavalos");
        break;

        case "alimentar_cavalos":
            gc_quest_set_stage("m3_viagem");
            gc_quest_start("viagem_cubicland");
        break;

        case "viagem_cubicland":
            gc_quest_set_stage("m4_cidadaos");
            gc_quest_start("ajudar_cidadaos");
        break;

        case "ajudar_cidadaos":
            gc_quest_set_stage("m5_exploracao");
            gc_quest_start("explorar_cubicland");
        break;

        case "explorar_cubicland":
            gc_quest_set_stage("pos_m5");
        break;
    }
}

function gc_quest_complete(_id) {
    var _q = gc_quest_get(_id);

    if (_q == noone) return false;
    if (_q.status == "concluida") return false;

    if (!gc_quest_all_objectives_complete(_q) && _q.status != "pronta") {
        return false;
    }

    _q.status = "concluida";

    gc_state_flag_set("quest_" + _q.id_m + "_concluida", true);
    gc_state_counter_add("missoes_concluidas", 1);

    if (_q.id_m == "treino_gmd") global.missao1_terminou = true;
    if (_q.id_m == "alimentar_cavalos") global.missao2_terminou = true;

    gc_quest_toast("Missao concluida: " + _q.nome, 220);
    gc_quest_apply_rewards(_q);

    show_debug_message("[QUEST] Concluida: " + _q.id_m);

    gc_quest_chain(_q.id_m);

    // Se a missao rastreada acabou, seleciona automaticamente outra ativa.
    if (global.game_state.runtime.tracked_quest_id == _q.id_m) {
        global.game_state.runtime.tracked_quest_id = "";
        gc_quest_get_tracked();
    }

    return true;
}

function gc_quest_notify(_type, _target, _amount = 1) {
    if (!variable_global_exists("missoes") || !is_array(global.missoes)) return false;

    var _changed = false;

    for (var _qi = 0; _qi < array_length(global.missoes); _qi++) {
        var _q = global.missoes[_qi];

        if (!is_struct(_q) || _q.status != "ativa") continue;
        if (!variable_struct_exists(_q, "objetivos") || !is_array(_q.objetivos)) continue;

        var _quest_changed = false;

        for (var _oi = 0; _oi < array_length(_q.objetivos); _oi++) {
            var _o = _q.objetivos[_oi];

            if (_o.complete) continue;
            if (_o.type != _type) continue;
            if (_o.target != "*" && string(_o.target) != string(_target)) continue;

            _o.current = clamp(_o.current + _amount, 0, _o.required);
            _o.complete = (_o.current >= _o.required);

            _quest_changed = true;
            _changed = true;

            if (_o.complete) {
                gc_quest_toast("Objetivo concluido: " + _o.label, 150);
            }
            else {
                gc_quest_toast(
                    _o.label + ": " + string(_o.current) + "/" + string(_o.required),
                    90
                );
            }
        }

        if (_quest_changed && gc_quest_all_objectives_complete(_q)) {
            _q.status = "pronta";
            gc_state_flag_set("quest_" + _q.id_m + "_objetivos", true);

            if (_q.id_m == "treino_gmd") global.missao1_terminou = true;

            if (variable_struct_exists(_q, "auto_complete") && _q.auto_complete) {
                gc_quest_complete(_q.id_m);
            }
            else {
                gc_quest_toast("Objetivos completos: " + _q.nome, 180);
            }
        }
    }

    return _changed;
}

function gc_quest_repair_progression() {
    // Migra saves da v2: se uma missao antiga ja foi concluida,
    // inicia o proximo passo novo sem apagar nenhum progresso.
    if (gc_quest_is_done("m001_almudeao")) {
        var _m2 = gc_quest_get("alimentar_cavalos");
        if (_m2 != noone && _m2.status == "bloqueada") gc_quest_start("alimentar_cavalos");
    }

    if (gc_quest_is_done("alimentar_cavalos")) {
        var _m3 = gc_quest_get("viagem_cubicland");
        if (_m3 != noone && _m3.status == "bloqueada") gc_quest_start("viagem_cubicland");
    }

    if (gc_quest_is_done("viagem_cubicland")) {
        var _m4 = gc_quest_get("ajudar_cidadaos");
        if (_m4 != noone && _m4.status == "bloqueada") gc_quest_start("ajudar_cidadaos");
    }

    if (gc_quest_is_done("ajudar_cidadaos")) {
        var _m5 = gc_quest_get("explorar_cubicland");
        if (_m5 != noone && _m5.status == "bloqueada") gc_quest_start("explorar_cubicland");
    }
}

function gc_quest_export() {
    var _out = [];

    if (!variable_global_exists("missoes") || !is_array(global.missoes)) return _out;

    for (var _i = 0; _i < array_length(global.missoes); _i++) {
        var _q = global.missoes[_i];
        if (!is_struct(_q)) continue;

        var _obj = [];

        if (variable_struct_exists(_q, "objetivos") && is_array(_q.objetivos)) {
            for (var _j = 0; _j < array_length(_q.objetivos); _j++) {
                array_push(_obj, {
                    current : _q.objetivos[_j].current,
                    complete : _q.objetivos[_j].complete
                });
            }
        }

        array_push(_out, {
            id_m : _q.id_m,
            status : _q.status,
            objetivos : _obj
        });
    }

    return _out;
}

function gc_quest_import(_saved) {
    if (!is_array(_saved)) return false;

    for (var _i = 0; _i < array_length(_saved); _i++) {
        var _sq = _saved[_i];

        if (!is_struct(_sq) || !variable_struct_exists(_sq, "id_m")) continue;

        var _q = gc_quest_get(_sq.id_m);
        if (_q == noone) continue;

        if (variable_struct_exists(_sq, "status")) {
            _q.status = _sq.status;
        }

        if (variable_struct_exists(_sq, "objetivos")
        && is_array(_sq.objetivos)
        && variable_struct_exists(_q, "objetivos")
        && is_array(_q.objetivos)) {

            var _count = min(array_length(_sq.objetivos), array_length(_q.objetivos));

            for (var _j = 0; _j < _count; _j++) {
                var _so = _sq.objetivos[_j];

                if (variable_struct_exists(_so, "current")) {
                    _q.objetivos[_j].current = clamp(
                        _so.current,
                        0,
                        _q.objetivos[_j].required
                    );
                }

                if (variable_struct_exists(_so, "complete")) {
                    _q.objetivos[_j].complete = _so.complete;
                }
            }
        }
    }

    return true;
}

// Ponte com nomes antigos espalhados pelo projeto.
function scr_missoes_notificar(_tipo, _alvo, _quantidade = 1) {
    return gc_quest_notify(_tipo, _alvo, _quantidade);
}

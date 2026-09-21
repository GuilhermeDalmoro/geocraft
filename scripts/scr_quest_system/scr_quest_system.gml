/// @description Sistema de missoes orientado a eventos.

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

function gc_quest_make(_id, _name, _desc, _objectives, _rewards = [], _auto_complete = false, _hidden = false) {
    return {
        id_m : _id,
        nome : _name,
        descricao : _desc,
        status : "bloqueada",
        objetivos : _objectives,
        recompensas : _rewards,
        auto_complete : _auto_complete,
        hidden : _hidden
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
            true
        ),

        gc_quest_make(
            "m001_almudeao",
            "Comunique Almudeao",
            "Conte ao Almudeao o que aconteceu depois do contato com o dejeto.",
            [
                gc_quest_objective("falar", "Missao Cavalos", 1, "Fale com Almudeao")
            ],
            [
                { type : "moedas", amount : 10 }
            ],
            true
        ),

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
            false
        ),

        gc_quest_make(
            "alimentar_cavalos",
            "Cafe da manha quadrupede",
            "Ajude no estabulo antes da viagem para CúbicLand.",
            [
                gc_quest_objective("alimentar", "cavalo", 4, "Alimente os cavalos")
            ],
            [
                { type : "moedas", amount : 20 }
            ],
            true
        ),

        gc_quest_make(
            "viagem_cubicland",
            "Rumo a CúbicLand",
            "Escolha um cavalo e siga viagem para o centro de CúbicLand.",
            [
                gc_quest_objective("montar", "cavalo", 1, "Monte em um cavalo"),
                gc_quest_objective("visitar", "Room6", 1, "Chegue ao centro de CúbicLand")
            ],
            [
                { type : "moedas", amount : 30 }
            ],
            true
        ),

        gc_quest_make(
            "explorar_cubicland",
            "Faxina geometrica",
            "Explore CúbicLand e reduza a populacao de monstros hostis.",
            [
                gc_quest_objective("matar", "inimigo", 10, "Derrote monstros em CúbicLand")
            ],
            [
                { type : "moedas", amount : 50 }
            ],
            true
        ),

        gc_quest_make(
            "andrius",
            "O guardiao Andrius",
            "Enfrente Andrius e sobreviva ao caos cubico.",
            [
                gc_quest_objective("matar", "andrius", 1, "Derrote Andrius")
            ],
            [
                { type : "moedas", amount : 100 }
            ],
            true
        )
    ];
}

function gc_quest_get(_id) {
    if (!variable_global_exists("missoes") || !is_array(global.missoes)) return noone;
    for (var _i = 0; _i < array_length(global.missoes); _i++) {
        var _q = global.missoes[_i];
        if (is_struct(_q) && variable_struct_exists(_q, "id_m") && _q.id_m == _id) return _q;
    }
    return noone;
}

function gc_quest_toast(_text, _frames = 180) {
    gc_game_state_bootstrap();
    global.game_state.runtime.toast_text = _text;
    global.game_state.runtime.toast_timer = _frames;
}

function gc_quest_reconcile(_q) {
    if (!is_struct(_q) || !variable_struct_exists(_q, "objetivos") || !is_array(_q.objetivos)) return;

    gc_game_state_bootstrap();

    for (var _i = 0; _i < array_length(_q.objetivos); _i++) {
        var _o = _q.objetivos[_i];
        if (_o.complete) continue;

        if (_o.type == "alimentar" && _o.target == "cavalo") {
            _o.current = max(_o.current, min(_o.required, global.cabalos_alimentados));
        }
        else if (_o.type == "montar" && _o.target == "cavalo") {
            if (instance_exists(obj_sdash)) {
                var _s = instance_find(obj_sdash, 0);
                if (variable_instance_exists(_s, "montado") && _s.montado) {
                    _o.current = _o.required;
                }
            }
        }
        else if (_o.type == "visitar") {
            var _visited = global.game_state.world.visited_rooms;
            for (var _v = 0; _v < array_length(_visited); _v++) {
                if (_visited[_v] == _o.target) {
                    _o.current = _o.required;
                    break;
                }
            }
        }

        _o.complete = (_o.current >= _o.required);
    }
}

function gc_quest_start(_id) {
    gc_game_state_bootstrap();
    var _q = gc_quest_get(_id);
    if (_q == noone) {
        show_debug_message("[QUEST] Missao inexistente: " + string(_id));
        return false;
    }

    if (_q.status == "concluida" || _q.status == "ativa" || _q.status == "pronta") return false;

    _q.status = "ativa";
    gc_quest_reconcile(_q);

    gc_quest_toast("Nova missao: " + _q.nome, 240);
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
    if (!is_struct(_q) || !variable_struct_exists(_q, "objetivos")) return true;
    if (!is_array(_q.objetivos)) return true;
    if (array_length(_q.objetivos) == 0) return true;

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
                var _amount = variable_struct_exists(_r, "amount") ? _r.amount : 0;
                global.moedas += _amount;
                gc_game_state_sync_from_legacy();
            break;

            case "flag":
                if (variable_struct_exists(_r, "name")) gc_state_flag_set(_r.name, true);
            break;
        }
    }
}

function gc_quest_complete(_id) {
    var _q = gc_quest_get(_id);
    if (_q == noone) return false;
    if (_q.status == "concluida") return false;

    if (!gc_quest_all_objectives_complete(_q) && _q.status != "pronta") return false;

    _q.status = "concluida";
    gc_quest_apply_rewards(_q);
    gc_state_flag_set("quest_" + _q.id_m + "_concluida", true);

    if (_q.id_m == "treino_gmd") global.missao1_terminou = true;
    if (_q.id_m == "alimentar_cavalos") global.missao2_terminou = true;

    gc_quest_toast("Missao concluida: " + _q.nome, 240);
    show_debug_message("[QUEST] Concluida: " + _q.id_m);

    // Encadeamento do primeiro arco ja existente no jogo.
    switch (_q.id_m) {
        case "alimentar_cavalos":
            gc_quest_start("viagem_cubicland");
        break;

        case "viagem_cubicland":
            gc_quest_start("explorar_cubicland");
        break;
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
            if (_o.target != "*" && _o.target != _target) continue;

            _o.current = clamp(_o.current + _amount, 0, _o.required);
            _o.complete = (_o.current >= _o.required);
            _quest_changed = true;
            _changed = true;

            gc_quest_toast(_o.label + ": " + string(_o.current) + "/" + string(_o.required), 120);
        }

        if (_quest_changed && gc_quest_all_objectives_complete(_q)) {
            _q.status = "pronta";
            gc_state_flag_set("quest_" + _q.id_m + "_objetivos", true);

            // Ponte com controllers antigos de missao/cutscene.
            if (_q.id_m == "treino_gmd") global.missao1_terminou = true;

            gc_quest_toast("Objetivos completos: " + _q.nome, 200);

            if (variable_struct_exists(_q, "auto_complete") && _q.auto_complete) {
                gc_quest_complete(_q.id_m);
            }
        }
    }

    return _changed;
}

function gc_quest_get_tracked() {
    if (!variable_global_exists("missoes") || !is_array(global.missoes)) return noone;

    for (var _i = 0; _i < array_length(global.missoes); _i++) {
        var _q = global.missoes[_i];
        if (!is_struct(_q)) continue;
        if (variable_struct_exists(_q, "hidden") && _q.hidden) continue;
        if (_q.status == "ativa" || _q.status == "pronta") return _q;
    }

    return noone;
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

        if (variable_struct_exists(_sq, "status")) _q.status = _sq.status;

        if (variable_struct_exists(_sq, "objetivos") && is_array(_sq.objetivos)
        && variable_struct_exists(_q, "objetivos") && is_array(_q.objetivos)) {
            var _count = min(array_length(_sq.objetivos), array_length(_q.objetivos));

            for (var _j = 0; _j < _count; _j++) {
                var _so = _sq.objetivos[_j];
                if (variable_struct_exists(_so, "current")) _q.objetivos[_j].current = _so.current;
                if (variable_struct_exists(_so, "complete")) _q.objetivos[_j].complete = _so.complete;
            }
        }
    }

    return true;
}

// Ponte com os nomes antigos ja espalhados pelo projeto.
function scr_missoes_notificar(_tipo, _alvo, _quantidade = 1) {
    return gc_quest_notify(_tipo, _alvo, _quantidade);
}

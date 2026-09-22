if (!variable_global_exists("game_state") || !is_struct(global.game_state)) {
    gc_game_state_bootstrap();
}

// Mantem os sistemas antigos conversando com o estado novo.
gc_game_state_sync_from_legacy();

// Fila de notificacoes de missao/recompensa.
gc_quest_toast_step();

// Detecta entrada de room uma unica vez e transforma isso em evento de missao.
if (room != last_room_seen) {
    last_room_seen = room;

    var _room_name = room_get_name(room);

    gc_world_room_entered(_room_name);
    gc_world_restore_room(_room_name);
    gc_quest_notify("visitar", _room_name, 1);
}

// Diario de missoes.
// So abre se nenhum outro sistema estiver segurando o pause.
if (keyboard_check_pressed(ord("M"))
&& !global.dialogo_acontecendo
&& !global.pause_por_inventario) {

    if (global.game_state.runtime.quest_journal_open) {
        global.game_state.runtime.quest_journal_open = false;

        if (journal_pause_owned) {
            global.pause = false;
            global.game_state.runtime.pause = false;
            journal_pause_owned = false;
        }
    }
    else if (!global.pause) {
        global.game_state.runtime.quest_journal_open = true;
        global.pause = true;
        global.game_state.runtime.pause = true;
        journal_pause_owned = true;

        var _visible_open = gc_quest_get_visible();
        journal_selected = clamp(
            journal_selected,
            0,
            max(0, array_length(_visible_open) - 1)
        );

        // Abre o diario ja apontando para a missao rastreada.
        var _tracked_open = gc_quest_get_tracked();

        if (_tracked_open != noone) {
            for (var _ji = 0; _ji < array_length(_visible_open); _ji++) {
                if (_visible_open[_ji].id_m == _tracked_open.id_m) {
                    journal_selected = _ji;
                    break;
                }
            }
        }
    }
}

// Navegacao do diario.
if (global.game_state.runtime.quest_journal_open) {
    var _visible = gc_quest_get_visible();
    var _count = array_length(_visible);

    if (_count > 0) {
        var _move =
            keyboard_check_pressed(ord("S"))
            + keyboard_check_pressed(vk_down)
            - keyboard_check_pressed(ord("W"))
            - keyboard_check_pressed(vk_up);

        if (_move != 0) {
            journal_selected = clamp(
                journal_selected + sign(_move),
                0,
                _count - 1
            );
        }

        if (keyboard_check_pressed(vk_enter)
        || gamepad_button_check_pressed(global.controle, gp_face1)) {

            var _chosen = _visible[journal_selected];

            if (_chosen.status == "ativa" || _chosen.status == "pronta") {
                if (gc_quest_track(_chosen.id_m)) {
                    gc_quest_toast("Rastreando: " + _chosen.nome, 100);
                }
            }
        }
    }
    else {
        journal_selected = 0;
    }

    if (keyboard_check_pressed(vk_escape)) {
        global.game_state.runtime.quest_journal_open = false;

        if (journal_pause_owned) {
            global.pause = false;
            global.game_state.runtime.pause = false;
            journal_pause_owned = false;
        }
    }
}

// Debug de campanha.
if (keyboard_check_pressed(vk_f10)) {
    global.game_state.runtime.debug_open = !global.game_state.runtime.debug_open;
}

// F9 liga/desliga atalhos internos de desenvolvimento.
if (keyboard_check_pressed(vk_f9)) {
    global.game_state.runtime.dev_mode = !global.game_state.runtime.dev_mode;

    gc_quest_toast(
        global.game_state.runtime.dev_mode ? "DEV MODE: ON" : "DEV MODE: OFF",
        90
    );
}

// Atalhos uteis do DEV MODE. So funcionam quando F9 esta ligado.
if (global.game_state.runtime.dev_mode
&& !global.dialogo_acontecendo
&& !global.game_state.runtime.quest_journal_open) {

    if (keyboard_check_pressed(vk_f1)) {
        global.moedas += 100;
        gc_game_state_sync_from_legacy();
        gc_quest_toast("DEV: +100 moedas", 70);
    }

    if (keyboard_check_pressed(vk_f2)) {
        if (variable_global_exists("inventario_slots")
        && ds_exists(global.inventario_slots, ds_type_grid)) {
            adiciona_ao_inventario(ITENS.madeira, 32);
            adiciona_ao_inventario(ITENS.pedra, 32);
            adiciona_ao_inventario(ITENS.flor, 12);
            adiciona_ao_inventario(ITENS.reia, 8);
            gc_quest_toast("DEV: materiais adicionados", 80);
        }
    }

    if (keyboard_check_pressed(vk_f3) && instance_exists(obj_sdash)) {
        var _dev_sdash = instance_find(obj_sdash, 0);
        _dev_sdash.vida = _dev_sdash.max_vida;
        _dev_sdash.estamina = _dev_sdash.max_estamina;
        gc_quest_toast("DEV: vida e estamina restauradas", 80);
    }

    if (keyboard_check_pressed(vk_f4)) {
        for (var _mi = 0; _mi < 5; _mi++) {
            gc_state_magic_set(_mi, true);
        }
        gc_quest_toast("DEV: todas as magias desbloqueadas", 90);
    }

    if (keyboard_check_pressed(vk_f6)) {
        var _dev_q = gc_quest_get_tracked();

        if (_dev_q != noone) {
            if (is_array(_dev_q.objetivos)) {
                for (var _oi = 0; _oi < array_length(_dev_q.objetivos); _oi++) {
                    _dev_q.objetivos[_oi].current = _dev_q.objetivos[_oi].required;
                    _dev_q.objetivos[_oi].complete = true;
                }
            }

            _dev_q.status = "pronta";
            gc_quest_complete(_dev_q.id_m);
            gc_quest_toast("DEV: missao rastreada concluida", 90);
        }
        else {
            gc_quest_toast("DEV: nenhuma missao rastreada", 70);
        }
    }

    if (keyboard_check_pressed(vk_f8)) {
        if (variable_global_exists("salva_jogo")) {
            global.salva_jogo();
        }
    }
}

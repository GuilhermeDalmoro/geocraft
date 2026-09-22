if (!variable_global_exists("game_state") || !is_struct(global.game_state)) {
    gc_game_state_bootstrap();
}

// Pequeno lock evita que a mesma tecla abra e feche uma UI no mesmo frame.
if (!variable_struct_exists(global.game_state.runtime, "interaction_lock")) {
    global.game_state.runtime.interaction_lock = 0;
}

if (global.game_state.runtime.interaction_lock > 0) {
    global.game_state.runtime.interaction_lock--;
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

// F9 abre o DEV Console completo.
// O proprio obj_dev_console cuida de fechar com F9 para evitar toggle duplo.
if (keyboard_check_pressed(vk_f9)
&& !global.game_state.runtime.dev_mode
&& !instance_exists(obj_dev_console)
&& !global.dialogo_acontecendo
&& !global.game_state.runtime.quest_journal_open) {

    instance_create_depth(0, 0, -1000000, obj_dev_console);
}

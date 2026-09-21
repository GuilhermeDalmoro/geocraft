if (!variable_global_exists("game_state") || !is_struct(global.game_state)) {
    gc_game_state_bootstrap();
}

// Mantem os sistemas antigos conversando com o estado novo.
gc_game_state_sync_from_legacy();

// Detecta entrada de room uma unica vez e transforma isso em evento de missao.
if (room != last_room_seen) {
    last_room_seen = room;
    var _room_name = room_get_name(room);
    gc_world_room_entered(_room_name);
    gc_quest_notify("visitar", _room_name, 1);
}

// Toast de progresso/conclusao.
if (global.game_state.runtime.toast_timer > 0) {
    global.game_state.runtime.toast_timer--;
}

// Diario de missoes.
if (keyboard_check_pressed(ord("M"))
&& !global.dialogo_acontecendo
&& !global.pause_por_inventario) {

    var _open = !global.game_state.runtime.quest_journal_open;
    global.game_state.runtime.quest_journal_open = _open;

    if (_open) {
        if (!global.pause) {
            global.pause = true;
            journal_pause_owned = true;
        }
    } else {
        if (journal_pause_owned) {
            global.pause = false;
            journal_pause_owned = false;
        }
    }
}

// Debug de campanha. Nao interfere na gameplay.
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

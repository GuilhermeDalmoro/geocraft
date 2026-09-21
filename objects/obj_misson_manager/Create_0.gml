/// Gerenciador persistente de campanha e missoes.
if (instance_number(obj_misson_manager) > 1) {
    instance_destroy();
    exit;
}

gc_game_state_bootstrap();
gc_world_restore_room(room_get_name(room));

last_room_seen = room;
journal_pause_owned = false;

// O diario abre com M. F10 mostra informacoes tecnicas do estado.
global.game_state.runtime.quest_journal_open = false;
global.game_state.runtime.debug_open = false;

show_debug_message("[GEOCRAFT] GameState v2 e QuestSystem carregados.");

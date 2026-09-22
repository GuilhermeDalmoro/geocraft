/// Gerenciador persistente de campanha e missoes.
if (instance_number(obj_misson_manager) > 1) {
    instance_destroy();
    exit;
}

gc_game_state_bootstrap();
gc_quest_repair_progression();

gc_world_room_entered(room_get_name(room));
gc_world_restore_room(room_get_name(room));

last_room_seen = room;
journal_pause_owned = false;
journal_selected = 0;

global.game_state.runtime.quest_journal_open = false;
global.game_state.runtime.debug_open = false;

show_debug_message("[GEOCRAFT] GameState v3 + QuestSystem v3 carregados.");

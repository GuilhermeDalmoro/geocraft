if (variable_instance_exists(id, "ui_open") && ui_open) {
    global.pause = false;

    if (variable_global_exists("game_state") && is_struct(global.game_state)) {
        global.game_state.runtime.pause = false;

        if (variable_struct_exists(global.game_state.runtime, "modal_ui")
        && global.game_state.runtime.modal_ui == "fornalha") {
            global.game_state.runtime.modal_ui = "";
        }
    }
}

// Compatibilidade com a versao antiga da fornalha.
if (variable_instance_exists(id, "fornalha_slots")) {
    if (ds_exists(fornalha_slots, ds_type_grid)) {
        ds_grid_destroy(fornalha_slots);
    }
}

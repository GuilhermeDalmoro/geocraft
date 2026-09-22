if (variable_global_exists("game_state") && is_struct(global.game_state)) {
    if (variable_struct_exists(global.game_state.runtime, "modal_ui")
    && global.game_state.runtime.modal_ui == "dev_console") {
        global.game_state.runtime.modal_ui = "";
        global.game_state.runtime.pause = false;
        global.game_state.runtime.dev_mode = false;
    }
}

global.pause = false;

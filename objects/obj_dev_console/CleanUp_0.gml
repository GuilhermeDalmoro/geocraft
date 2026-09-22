if (variable_global_exists("game_state") && is_struct(global.game_state)) {
    global.game_state.runtime.dev_mode = false;

    if (variable_struct_exists(global.game_state.runtime, "modal_ui")
    && global.game_state.runtime.modal_ui == "dev_console") {
        global.game_state.runtime.modal_ui = "";
    }

    global.game_state.runtime.pause = previous_pause;
}

global.pause = previous_pause;

keyboard_string = "";

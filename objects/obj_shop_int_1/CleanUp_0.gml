var _owned_modal = false;

if (variable_global_exists("game_state") && is_struct(global.game_state)) {
    if (variable_struct_exists(global.game_state.runtime, "modal_ui")
    && global.game_state.runtime.modal_ui == "loja") {
        global.game_state.runtime.modal_ui = "";
        global.game_state.runtime.pause = false;
        _owned_modal = true;
    }
}

if (_owned_modal) {
    global.pause = false;
}

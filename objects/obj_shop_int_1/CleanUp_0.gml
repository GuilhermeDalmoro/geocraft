if (variable_global_exists("game_state") && is_struct(global.game_state)) {
    if (variable_struct_exists(global.game_state.runtime, "modal_ui")
    && global.game_state.runtime.modal_ui == "loja") {
        global.game_state.runtime.modal_ui = "";
        global.game_state.runtime.pause = false;
    }
}

if (!instance_exists(obj_fornalha)) {
    global.pause = false;
}

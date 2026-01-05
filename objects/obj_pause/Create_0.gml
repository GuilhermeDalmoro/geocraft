if (!variable_global_exists("pause_menu")) {
    global.pause_menu = {
        active: false,
        selected: 0,
        options: ["Continuar", "Menu Principal"]
    };
}

global.pause = false;
bg_alpha = 0;
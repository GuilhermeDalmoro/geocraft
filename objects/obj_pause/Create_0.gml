if (instance_number(obj_pause) > 1) {
    instance_destroy();
    exit;
}

if (!variable_global_exists("save_slot")) {
    global.save_slot = 1;
}

global.pause_menu = {
    active : false,
    selected : 0,
    options : [
        "Continuar",
        "Salvar jogo",
        "Diario de missoes",
        "Opcoes",
        "Salvar e voltar ao menu"
    ]
};

pause_page = 0; // 0 principal, 1 opcoes
option_selected = 0;
bg_alpha = 0;

pause_fullscreen = window_get_fullscreen();
pause_volume = variable_global_exists("volume_mestre") ? global.volume_mestre : 1;

if (!variable_global_exists("dificuldade")) {
    global.dificuldade = 1;
}

global.pause = false;

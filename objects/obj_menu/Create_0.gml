enum MENU_ESTADO {
    principal,
    novo_slot,
    carregar_slot,
    mundos,
    opcoes
}

if (!variable_global_exists("controle")) {
    global.controle = -1;
}

// Garante que Save/Load exista ja no menu inicial.
if (!instance_exists(obj_data)) {
    instance_create_layer(0, 0, "Instances", obj_data);
}

estado = MENU_ESTADO.principal;

selected_main = 0;
selected_slot = 0;
selected_world = 0;
selected_option = 0;

confirm_overwrite = false;
confirm_slot = -1;

main_options = [
    "CONTINUAR",
    "NOVO JOGO",
    "CARREGAR JOGO",
    "MUNDOS",
    "OPCOES",
    "CREDITOS",
    "SAIR"
];

world_options = [
    "MUNDO FACIL",
    "HARDCORE",
    "CONSTRUCAO"
];

bg_alpha = 0;
title_float = 0;

var _default_volume = variable_global_exists("volume_mestre") ? global.volume_mestre : 1;
var _default_dificuldade = variable_global_exists("dificuldade") ? global.dificuldade : 1;

global.volume_mestre = _default_volume;
global.dificuldade = _default_dificuldade;

fullscreen = window_get_fullscreen();
last_slot = 1;

if (file_exists("config.ini")) {
    ini_open("config.ini");

    global.volume_mestre = clamp(
        ini_read_real("audio", "volume", global.volume_mestre),
        0,
        1
    );

    fullscreen = (
        ini_read_real("video", "fullscreen", fullscreen ? 1 : 0) >= 0.5
    );

    global.dificuldade = clamp(
        round(ini_read_real("game", "dificuldade", global.dificuldade)),
        0,
        2
    );

    last_slot = clamp(round(ini_read_real("save", "last_slot", 1)), 1, 3);

    ini_close();
}

audio_master_gain(global.volume_mestre);
window_set_fullscreen(fullscreen);

volume_visual = global.volume_mestre;

save_meta = [];

refresh_saves = function() {
    save_meta = [
        global.save_slot_meta(1),
        global.save_slot_meta(2),
        global.save_slot_meta(3)
    ];
};

get_continue_slot = function() {
    if (save_meta[last_slot - 1].exists) {
        return last_slot;
    }

    for (var _i = 0; _i < 3; _i++) {
        if (save_meta[_i].exists) return _i + 1;
    }

    return -1;
};

save_options = function() {
    ini_open("config.ini");
    ini_write_real("audio", "volume", global.volume_mestre);
    ini_write_real("video", "fullscreen", fullscreen ? 1 : 0);
    ini_write_real("game", "dificuldade", global.dificuldade);
    ini_write_real("save", "last_slot", last_slot);
    ini_close();
};

refresh_saves();

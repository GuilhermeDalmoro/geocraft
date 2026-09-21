//================ ENUM DE ESTADOS ================
enum MENU_ESTADO {
    principal,
    mundos,
    opcoes
}

estado = MENU_ESTADO.principal;
estado_desejado = estado;

//================ LAYOUT =========================
op_y_inicio = room_height * 0.28;
op_espaco   = 64;

//================ ANIMAÇÕES ======================
alpha_menu  = 0;
escala_menu = 0.9;

//================ HOVER ==========================
hover = -1;
hover_antigo = -1;

//================ ESCALAS INDIVIDUAIS ============
menu_scale = array_create(20, 1);

//================ AUDIO / CONFIG =================
// Configuracoes persistem entre sessoes.
var _default_volume = variable_global_exists("volume_mestre") ? global.volume_mestre : 1;
var _default_dificuldade = variable_global_exists("dificuldade") ? global.dificuldade : 1;

global.volume_mestre = _default_volume;
global.dificuldade = _default_dificuldade;
fullscreen = window_get_fullscreen();

if (file_exists("config.ini")) {
    ini_open("config.ini");
    global.volume_mestre = clamp(ini_read_real("audio", "volume", global.volume_mestre), 0, 1);
    fullscreen = (ini_read_real("video", "fullscreen", fullscreen ? 1 : 0) >= 0.5);
    global.dificuldade = clamp(round(ini_read_real("game", "dificuldade", global.dificuldade)), 0, 2);
    ini_close();
}

audio_master_gain(global.volume_mestre);
window_set_fullscreen(fullscreen);

volume_visual = global.volume_mestre;

//================ SLIDER =========================
slider_x_inicio = room_width * 0.28;
slider_x_fim    = room_width * 0.72;
slider_comprimento = slider_x_fim - slider_x_inicio;
slider_y = op_y_inicio + 35;

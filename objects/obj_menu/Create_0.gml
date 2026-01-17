//// Enum pros estados do menu (principal > mundos/opcoes)
//enum menu_estado {
    //principal,
    //mundos,
    //opcoes
//}
//
//// Estado inicial: Menu principal
//estado = menu_estado.principal;
//
//// Posições CÚBICAS (centro da tela, ajusta auto!)
//op_y_inicio = room_height * 0.28;
//op_espaco = 64;
//
//// VOLUME MESTRE GLOBAL (salva e usa no jogo todo!)
//global.volume_mestre = 1 // Pega atual ou default 1.0
//volume_visual = global.volume_mestre;
//
//// Slider fofo (barra rosa Sdash!)
//slider_x_inicio = room_width * 0.28;
//slider_x_fim = room_width * 0.72;
//slider_comprimento = slider_x_fim - slider_x_inicio;
//slider_y = op_y_inicio + 35;
//
//// Configs do Sdash
//fullscreen = window_get_fullscreen();
//global.dificuldade = 1; // 0=Fácil, 1=Normal, 2=Difícil (usa no jogo!)
//vibracao = true; // Futuro: gamepad rumble cúbico
//
//// Animações vibrantes (fade + escala pro carisma!)
//alpha_menu = 0;
//escala_menu = 0.9;
//hover = -1; // Reset hover


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
global.volume_mestre = 1
fullscreen           = false
global.dificuldade   = 1


audio_master_gain(global.volume_mestre);
window_set_fullscreen(fullscreen);

volume_visual = global.volume_mestre;

//================ SLIDER =========================
slider_x_inicio = room_width * 0.28;
slider_x_fim    = room_width * 0.72;
slider_comprimento = slider_x_fim - slider_x_inicio;
slider_y = op_y_inicio + 35;

//================ CURSOR =========================
//window_set_cursor(cr_none);

// Enum para estados do menu
enum menu_estado {
    principal,
    mundos,
    opcoes
}

// Vars iniciais
estado = menu_estado.principal; // Começa no principal

// Posições fixas para opções (centro da tela, ajuste se room mudar)
op_y_inicio = room_height / 2 - 100; // Y inicial para opções
op_espaco = 60; // Espaço entre opções

// Para submenu de opções
volume = audio_master_gain(1); // Volume inicial (0-1)
fullscreen = window_get_fullscreen(); // Estado atual da tela
global.dificuldade = 1; // 0=fácil, 1=normal, 2=hard (inicial normal)
vibracao = true; // Exemplo de outra config (global.vibracao = true; se quiser global)

// Para submenu de mundos: posições dos sprites (lado a lado)
mundo_x1 = room_width / 2 - 200;
mundo_x2 = room_width / 2;
mundo_x3 = room_width / 2 + 200;
mundo_y = room_height / 2;

// Vars para hover/clique (índice da opção selecionada)
hover = -1; // Nenhuma hover


////menu
//menu = ["Jogar", "Opções", "Mundos","Sair"]
////menu = ["Play", "Options","Worlds","Leave"]

////variavel pra eu saber o indice atual
//atual = 0;

//escala = 1;

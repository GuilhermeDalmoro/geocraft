// Verifica se a tecla Enter foi pressionada
if (keyboard_check_pressed(vk_enter)) {
    audio_play_sound(snd_blim, 0, false);  // Tocar o som snd_blim

    // Verifica a ação de acordo com a opção selecionada
    if (!submenu) {
        if (index == 0) {
            room_goto_next();  // Ir para a próxima sala (novo jogo)
        } else if (index == 2) {
            submenu = true;  // Entrar no submenu "Opções"
            index_sub = 0;
        } else if (index == 3) {
            game_end();  // Encerrar o jogo
        }
    } else {
        if (index_sub == 0) {
            // Ação para "Créditos"
        } else if (index_sub == 1) {
            // Ação para "Opções de Som"
        } else if (index_sub == 2) {
            // Ação para "Linguagem"
        } else if (index_sub == 3) {
            submenu = false;  // Voltar ao menu principal
            index = 2;  // Selecionar "Opções" novamente
        }
    }
}
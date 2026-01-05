// Verifica se o jogo está em modo de tela cheia
if (window_get_fullscreen()) {
    // Define o jogo para o modo de janela com o tamanho original
    window_set_fullscreen(false);
//    window_set_size(original_window_width, original_window_height); 
} else {
    window_set_fullscreen(true);
}

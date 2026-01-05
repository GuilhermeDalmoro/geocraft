// Verifica se a tecla para cima foi pressionada
if (keyboard_check_pressed(vk_up)) {
    if (!submenu) {
        index--;
        audio_play_sound(snd_navegation, 10, false);
        
        if (index < 0) {
            index = op_max - 1;
        }
    } else {
        index_sub--;
        audio_play_sound(snd_navegation, 10, false);
        
        if (index_sub < 0) {
            index_sub = op_sub_max - 1;
        }
    }
}
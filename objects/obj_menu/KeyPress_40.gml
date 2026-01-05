// Verifica se a tecla para baixo foi pressionada
if (keyboard_check_pressed(vk_down)) {
    if (!submenu) {
        index++;
        audio_play_sound(snd_navegation, 10, false);
        
        if (index > op_max - 1) {
            index = 0;
        }
    } else {
        index_sub++;
        audio_play_sound(snd_navegation, 10, false);
        
        if (index_sub > op_sub_max - 1) {
            index_sub = 0;
        }
    }
}
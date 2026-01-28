if (!aberto) exit;

if (!escolha_feita) {
    // Revelação gradual das estrelas
    if (estrelas_reveladas < estrelas_total) {
        timer_revelacao++;
        if (timer_revelacao >= 35 + estrelas_reveladas * 25) {   // um pouco mais rápido e ritmado
            estrelas_reveladas++;
            timer_revelacao = 0;
            // audio_play_sound(snd_estrela_revelada, 8, false);
            // partícula ou flash aqui se quiser
        }
    }
    
    // Clique para escolher
    if (estrelas_reveladas >= estrelas_total) {
        var gui_w = display_get_gui_width();
        var gui_h = display_get_gui_height();
        var loot_x = (gui_w - loot_w) div 2;
        var loot_y = (gui_h - loot_h) div 2;
        
        for (var i = 0; i < 3; i++) {
            var _x = loot_x + 80 + i * 180;     // mais espaço lateral (180 px entre centros)
            var _y = loot_y + 120;              // subiu um pouco pra centralizar melhor
            
            var slot_left   = _x - 40;
            var slot_top    = _y - 40;
            var slot_right  = _x + 40;
            var slot_bottom = _y + 40;
            
            if (mouse_check_button_pressed(mb_left) &&
                point_in_rectangle(device_mouse_x_to_gui(0), device_mouse_y_to_gui(0),
                                   slot_left, slot_top, slot_right, slot_bottom)) {
                
                escolha_index = i;
                escolha_feita = true;
                
                var escolhida = opcoes[i];
                escolhida.estrelas = estrelas_total;
                
                aplicar_insignia(escolhida);
                ds_list_add(global.insignias_adquiridas, escolhida);
                
                // audio_play_sound(snd_insignia_escolhida, 10, false);
                
                alarm[0] = 120;   // fecha mais rápido (2 segundos)
            }
        }
    }
}
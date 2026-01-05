// Reset hover
hover = -1;

// Checa com base no estado
switch (estado) {
    case menu_estado.principal:
        // 4 opções: Jogar, Mundos, Opções, Sair
        for (var i = 0; i < 4; i++) {
            var op_x = room_width / 2;
            var op_y = op_y_inicio + i * op_espaco;
            if (point_in_rectangle(mouse_x, mouse_y, op_x - 100, op_y - 20, op_x + 100, op_y + 20)) {
                hover = i;
                if (mouse_check_button_pressed(mb_left)) {
                    switch (i) {
                        case 0: // Jogar (normal)
                            room_goto(Room_intro); // Troque pela sua room
                            break;
                        case 1: // Mundos
                            estado = menu_estado.mundos;
                            break;
                        case 2: // Opções
                            estado = menu_estado.opcoes;
                            break;
                        case 3: // Sair
                            game_end();
                            break;
                    }
                }
            }
        }
        break;
    
    case menu_estado.mundos:
        // Checa cliques nos 3 sprites
        if (point_in_rectangle(mouse_x, mouse_y, mundo_x1 - 32, mundo_y - 32, mundo_x1 + 32, mundo_y + 32)) {
            hover = 0;
            if (mouse_check_button_pressed(mb_left)) {
                room_goto(rm_facil); // Troque pela room fácil
            }
        } else if (point_in_rectangle(mouse_x, mouse_y, mundo_x2 - 32, mundo_y - 32, mundo_x2 + 32, mundo_y + 32)) {
            hover = 1;
            if (mouse_check_button_pressed(mb_left)) {
                room_goto(rm_hardcore); // Troque pela room hardcore
            }
        } else if (point_in_rectangle(mouse_x, mouse_y, mundo_x3 - 32, mundo_y - 32, mundo_x3 + 32, mundo_y + 32)) {
            hover = 2;
            if (mouse_check_button_pressed(mb_left)) {
                room_goto(rm_construcao); // Troque pela room construção
            }
        }
        
        // ESC volta
        if (keyboard_check_pressed(vk_escape)) {
            estado = menu_estado.principal;
        }
        break;
    
    case menu_estado.opcoes:
        // Controles interativos (sliders, toggles)
        // Volume: Slider horizontal (ex: de x=400 a x=800, y=200)
        var vol_x1 = room_width / 2 - 200;
        var vol_y = op_y_inicio;
        var vol_x2 = room_width / 2 + 200;
        if (point_in_rectangle(mouse_x, mouse_y, vol_x1, vol_y - 10, vol_x2, vol_y + 10)) {
            if (mouse_check_button(mb_left)) {
                volume = (mouse_x - vol_x1) / (vol_x2 - vol_x1);
                volume = clamp(volume, 0, 1);
                audio_master_gain(volume);
            }
        }
        
        // Fullscreen: Toggle (clique para alternar)
        var fs_x = room_width / 2;
        var fs_y = op_y_inicio + op_espaco;
        if (point_in_rectangle(mouse_x, mouse_y, fs_x - 100, fs_y - 20, fs_x + 100, fs_y + 20)) {
            if (mouse_check_button_pressed(mb_left)) {
                fullscreen = !fullscreen;
                window_set_fullscreen(fullscreen);
            }
        }
        
        // Dificuldade: Ciclo entre 0,1,2 (clique para mudar)
        var dif_x = room_width / 2;
        var dif_y = op_y_inicio + 2 * op_espaco;
        if (point_in_rectangle(mouse_x, mouse_y, dif_x - 100, dif_y - 20, dif_x + 100, dif_y + 20)) {
            if (mouse_check_button_pressed(mb_left)) {
                global.dificuldade = (global.dificuldade + 1) % 3;
            }
        }
        
        // Vibração: Toggle exemplo
        var vib_x = room_width / 2;
        var vib_y = op_y_inicio + 3 * op_espaco;
        if (point_in_rectangle(mouse_x, mouse_y, vib_x - 100, vib_y - 20, vib_x + 100, vib_y + 20)) {
            if (mouse_check_button_pressed(mb_left)) {
                vibracao = !vibracao;
                // global.vibracao = vibracao; se quiser global
            }
        }
        
        // ESC volta
        if (keyboard_check_pressed(vk_escape)) {
            estado = menu_estado.principal;
        }
        break;
}
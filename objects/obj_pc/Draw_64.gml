//// obj_pc Draw GUI
//if (room == Room_pc && interface_aberta) {
//    draw_sprite(spr_fundo_pc, 0, 0, 0); // Fundo desktop
//    draw_set_color(c_white);
//    draw_set_font(fnt_dialogo);
    
//    if (!global.pc_jogando) {
//        // Ícones
//        var _pulse = 1 + sin(current_time * 0.005) * 0.1;
//        if (point_distance(mouse_x, mouse_y, 100, 100) < 50 && mouse_check_button_pressed(mb_left)) {
//            global.pc_jogando = true;
//            global.pc_score = 0;
//            global.pc_tempo = 0;
//           // audio_play_sound(snd_pc_click, 1, 0);
//        }
//        draw_sprite_ext(spr_icone_hackear, 0, 100, 100, _pulse, _pulse, 0, c_white, 1);
//        draw_text(80, 150, "Hackear");
        
//        if (point_distance(mouse_x, mouse_y, 200, 100) < 50 && mouse_check_button_pressed(mb_left)) {
//            obj_sdash.visible = true;
//            obj_sdash.active = true;
//            interface_aberta = false;
//            ds_list_clear(virus_list);
//            window_set_cursor(cr_default);
//            room_goto(Room_quarto_sdash);
//        }
//        draw_sprite_ext(spr_icone_sair, 0, 200, 100, _pulse, _pulse, 0, c_white, 1);
//        draw_text(190, 150, "Sair");
//    } else {
//        // Minigame
//        draw_text(20, 20, "Score: " + string(global.pc_score));
//        draw_text(20, 50, "Tempo: " + string(30 - global.pc_tempo div room_speed));
//        for (var i = 0; i < ds_list_size(virus_list); i++) {
//            var _virus = virus_list[| i];
//            var _pulse = 1 + sin(current_time * 0.005 + i) * 0.1;
//            draw_sprite_ext(_virus.sprite, 0, _virus.x, _virus.y, _pulse, _pulse, 0, c_white, 1);
//        }
//    }
//}
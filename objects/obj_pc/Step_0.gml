//// obj_pc Step
//if (room == Room_quarto_sdash && distance_to_object(obj_sdash) < 5 && !global.dialogo_acontecendo) {
//    if (keyboard_check_pressed(vk_enter)) {
//        obj_sdash.active = false;
//        obj_sdash.visible = false;
//        interface_aberta = true;
//        room_goto(Room_pc);
//        //audio_play_sound(snd_pc_click, 1, 0); // Som opcional
//    }
//}

//if (room == Room_pc) {
//    if (!global.pc_jogando && keyboard_check_pressed(vk_left)) {
//        obj_sdash.visible = true;
//        obj_sdash.active = true;
//        interface_aberta = false;
//        ds_list_clear(virus_list);
//        window_set_cursor(cr_default); // Restaura cursor
//        room_goto(Room_quarto_sdash);
//    }
    
//    if (global.pc_jogando) {
//        global.pc_tempo += 1;
//        // Spawna vírus (acelera com o tempo)
//        if (global.pc_tempo mod (room_speed * (3 - global.pc_tempo / (30 * room_speed))) == 0) {
//            var _virus = {
//                x: random_range(100, room_width - 100),
//                y: random_range(100, room_height - 100),
//                sprite: spr_virus_dejeto,
//                hp: 1
//            };
//            ds_list_add(virus_list, _virus);
//        }
        
//        // Clique destrói vírus
//        if (mouse_check_button_pressed(mb_left)) {
//            for (var i = ds_list_size(virus_list) - 1; i >= 0; i--) {
//                var _virus = virus_list[| i];
//                if (point_distance(mouse_x, mouse_y, _virus.x, _virus.y) < 30) {
//                    _virus.hp -= 1;
//                    if (_virus.hp <= 0) {
//                        global.pc_score += 10;
//                      //  audio_play_sound(snd_dejeto_splat, 1, 0);
//                        ds_list_delete(virus_list, i);
//                        // Efeito vitral
//                        repeat (10) {
//                            var _part = instance_create_layer(_virus.x, _virus.y, "Instances", obj_particula);
//                            _part.direction = random(360);
//                            _part.speed = random_range(1, 3);
//                            _part.sprite_index = spr_particula_vitral;
//                        }
//                    }
//                    break;
//                }
//            }
//        }
        
//        // Fim do minigame (30s)
//        if (global.pc_tempo >= 30 * room_speed) {
//            global.pc_jogando = false;
//            var _recompensa = global.pc_score div 100; // 1 moeda por 100 pontos
//            global.moedas += _recompensa;
//            if (_recompensa > 0) {
//                global.inventario_slots[# 0, 0] = global.itens[| ITENS.reia];
//            }
//            var _dialogo = instance_create_layer(0, 0, "Dialogo", obj_dialogo);
//            _dialogo.npc_nome = "PC_Fim";
//            global.dialogo_acontecendo = true;
//            ds_list_clear(virus_list);
//        }
//    }
//}

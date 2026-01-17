//// Animações suaves: Fade-in + escala como Sdash pulando!
//alpha_menu = lerp(alpha_menu, 1, 0.2);
//escala_menu = lerp(escala_menu, 1, 0.15);
//
//// Reset hover toda frame
//hover = -1;
//
//// DEBUG: R reseta tudo (útil pra testar!)
//if (keyboard_check_pressed(ord("R"))) {
    //estado = menu_estado.principal;
    //alpha_menu = 0;
    //show_debug_message(" RESET MENU! Sdash recarregou o chapéu!");
//}
//
//// Lógica por estado (cúbica e organizada!)
//switch (estado) {
    //case menu_estado.principal:
        //// 4 opções principais: Hover + clique
        //for (var i = 0; i < 4; i++) {
            //var op_x = room_width / 2;
            //var op_y = op_y_inicio + i * op_espaco;
            //if (point_in_rectangle(mouse_x, mouse_y, op_x - 140, op_y - 30, op_x + 140, op_y + 30)) {
                //hover = i;
                //if (mouse_check_button_pressed(mb_left)) {
                    //switch (i) {
                        //case 0: // JOGAR - Vai pra intro da aventura!
                            //room_goto(Room_intro); // Troque pela sua room de história
                            //break;
                        //case 1: // MUNDOS - Submenu cúbico!
                            //estado = menu_estado.mundos;
                            //break;
                        //case 2: // OPÇÕES - Configs do Sdash!
                            //estado = menu_estado.opcoes;
                            //break;
                        //case 3: // SAIR - Adeus CúbicLand :(
                            //game_end();
                            //break;
                    //}
                    ////audio_play_sound(snd_blip_menu, 10, false); // Som fofo de clique!
                //}
            //}
        //}
        //break;
//
    //case menu_estado.mundos:
        //// 3 mundos lado a lado (sprites: crie spr_mundo_facil, etc. 64x64 pixels!)
        //var tam_mundo = 64;
        //var mundo_x1 = room_width / 2 - 200;
        //var mundo_x2 = room_width / 2;
        //var mundo_x3 = room_width / 2 + 200;
        //var mundo_y = room_height / 2;
//
        //// Clique nos mundos
        //if (point_in_rectangle(mouse_x, mouse_y, mundo_x1 - tam_mundo/2, mundo_y - tam_mundo/2, mundo_x1 + tam_mundo/2, mundo_y + tam_mundo/2)) {
            //hover = 0;
            //if (mouse_check_button_pressed(mb_left)) room_goto(rm_facil);
        //} else if (point_in_rectangle(mouse_x, mouse_y, mundo_x2 - tam_mundo/2, mundo_y - tam_mundo/2, mundo_x2 + tam_mundo/2, mundo_y + tam_mundo/2)) {
            //hover = 1;
            //if (mouse_check_button_pressed(mb_left)) room_goto(rm_hardcore);
        //} else if (point_in_rectangle(mouse_x, mouse_y, mundo_x3 - tam_mundo/2, mundo_y - tam_mundo/2, mundo_x3 + tam_mundo/2, mundo_y + tam_mundo/2)) {
            //hover = 2;
            //if (mouse_check_button_pressed(mb_left)) room_goto(rm_construcao);
        //}
        //// ESC volta
        //if (keyboard_check_pressed(vk_escape)) estado = menu_estado.principal;
        //break;
//
    //case menu_estado.opcoes:
        //// SLIDER VOLUME - Arraste o knob rosa como Sdash no chapéu!
        //var slider_area_x1 = slider_x_inicio - 40;
        //var slider_area_x2 = slider_x_fim + 40;
        //var slider_area_y1 = slider_y - 25;
        //var slider_area_y2 = slider_y + 25;
        //if (point_in_rectangle(mouse_x, mouse_y, slider_area_x1, slider_area_y1, slider_area_x2, slider_area_y2)) {
            //hover = 10; // Hover especial pro slider
            //if (mouse_check_button(mb_left)) {
                //volume_visual = clamp((mouse_x - slider_x_inicio) / slider_comprimento, 0, 1);
                //global.volume_mestre = volume_visual;
                //audio_master_gain(global.volume_mestre);
            //}
        //}
//
        //// Toggle Fullscreen (clique!)
        //var fs_y = op_y_inicio + op_espaco * 2.2;
        //if (point_in_rectangle(mouse_x, mouse_y, room_width/2 - 150, fs_y - 35, room_width/2 + 150, fs_y + 35)) {
            //hover = 1;
            //if (mouse_check_button_pressed(mb_left)) {
                //fullscreen = !fullscreen;
                //window_set_fullscreen(fullscreen);
            //}
        //}
//
        //// Ciclo Dificuldade (clique!)
        //var dif_y = op_y_inicio + op_espaco * 3.8;
        //if (point_in_rectangle(mouse_x, mouse_y, room_width/2 - 150, dif_y - 35, room_width/2 + 150, dif_y + 35)) {
            //hover = 2;
            //if (mouse_check_button_pressed(mb_left)) {
                //global.dificuldade = (global.dificuldade + 1) % 3;
            //}
        //}
//
        //// VOLTAR (clique ou ESC)
        //var voltar_y = op_y_inicio + op_espaco * 6;
        //if (point_in_rectangle(mouse_x, mouse_y, room_width/2 - 120, voltar_y - 35, room_width/2 + 120, voltar_y + 35) || keyboard_check_pressed(vk_escape)) {
            //hover = 3;
            //estado = menu_estado.principal;
        //}
        //break;
//}

//============ FUNÇÃO BOTÃO TEXTO ================
function botao_texto(_x, _y, _w, _h, _id) {
    if (point_in_rectangle(mouse_x, mouse_y, _x-_w/2, _y-_h/2, _x+_w/2, _y+_h/2)) {
        hover = _id;
        if (mouse_check_button_pressed(mb_left)) return true;
    }
    return false;
}

//============ ANIMAÇÕES GERAIS ==================
alpha_menu  = lerp(alpha_menu, (estado == estado_desejado), 0.25);
escala_menu = lerp(escala_menu, 1, 0.15);

//============ ESCALA INDIVIDUAL =================
for (var i = 0; i < array_length(menu_scale); i++) {
    var alvo = (hover == i) ? 1.25 : 1;
    menu_scale[i] = lerp(menu_scale[i], alvo, 0.2);
}

//============ SOM DE HOVER ======================
if (hover != hover_antigo && hover != -1) {
    //audio_play_sound(snd_hover, 5, false);
}
hover_antigo = hover;

//============ RESET =============================
hover = -1;

//============ TROCA DE ESTADO SUAVE ==============
if (estado != estado_desejado && alpha_menu < 0.05) {
    estado = estado_desejado;
}

//============ INPUT POR ESTADO ==================
switch (estado) {

    case MENU_ESTADO.principal:
        if (botao_texto(room_width/2, op_y_inicio + 0*op_espaco, 280, 60, 0))
            room_goto(Room_intro);

        if (botao_texto(room_width/2, op_y_inicio + 1*op_espaco, 280, 60, 1))
            estado_desejado = MENU_ESTADO.mundos;

        if (botao_texto(room_width/2, op_y_inicio + 2*op_espaco, 280, 60, 2))
            estado_desejado = MENU_ESTADO.opcoes;

        if (botao_texto(room_width/2, op_y_inicio + 3*op_espaco, 280, 60, 3))
            game_end();
    break;

    case MENU_ESTADO.mundos:
        var mx = room_width/2;
        var my = room_height/2;

        if (point_in_rectangle(mouse_x, mouse_y, mx-260, my-40, mx-180, my+40)) {
            hover = 0;
            if (mouse_check_button_pressed(mb_left)) room_goto(rm_facil);
        }

        if (point_in_rectangle(mouse_x, mouse_y, mx-40, my-40, mx+40, my+40)) {
            hover = 1;
            if (mouse_check_button_pressed(mb_left)) room_goto(rm_hardcore);
        }

        if (point_in_rectangle(mouse_x, mouse_y, mx+180, my-40, mx+260, my+40)) {
            hover = 2;
            if (mouse_check_button_pressed(mb_left)) room_goto(rm_construcao);
        }

        if (keyboard_check_pressed(vk_escape))
            estado_desejado = MENU_ESTADO.principal;
    break;

    case MENU_ESTADO.opcoes:
        // SLIDER VOLUME
        if (mouse_check_button(mb_left)) {
            if (point_in_rectangle(mouse_x, mouse_y,
                slider_x_inicio-40, slider_y-20,
                slider_x_fim+40, slider_y+20)) {

                volume_visual = clamp((mouse_x - slider_x_inicio) / slider_comprimento, 0, 1);
                global.volume_mestre = volume_visual;
                audio_master_gain(global.volume_mestre);
            }
        }

        // FULLSCREEN
        if (botao_texto(room_width/2, op_y_inicio + op_espaco*2.2, 300, 60, 1)) {
            fullscreen = !fullscreen;
            window_set_fullscreen(fullscreen);
        }

        // DIFICULDADE
        if (botao_texto(room_width/2, op_y_inicio + op_espaco*3.8, 300, 60, 2)) {
            global.dificuldade = (global.dificuldade + 1) mod 3;
        }

        // VOLTAR
        if (botao_texto(room_width/2, op_y_inicio + op_espaco*6, 240, 60, 3)
        || keyboard_check_pressed(vk_escape)) {

            ini_open("config.ini");
            ini_write_real("audio", "volume", global.volume_mestre);
            ini_write_real("video", "fullscreen", fullscreen);
            ini_write_real("game", "dificuldade", global.dificuldade);
            ini_close();

            estado_desejado = MENU_ESTADO.principal;
        }
    break;
}

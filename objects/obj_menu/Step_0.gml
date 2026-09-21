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

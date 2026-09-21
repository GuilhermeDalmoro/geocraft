bg_alpha = lerp(bg_alpha, 1, 0.08);
title_float = sin(current_time * 0.0025) * 4;

var _gw = display_get_gui_width();
var _gh = display_get_gui_height();
var _mx = device_mouse_x_to_gui(0);
var _my = device_mouse_y_to_gui(0);

var _up = keyboard_check_pressed(ord("W")) || keyboard_check_pressed(vk_up);
var _down = keyboard_check_pressed(ord("S")) || keyboard_check_pressed(vk_down);
var _left = keyboard_check_pressed(ord("A")) || keyboard_check_pressed(vk_left);
var _right = keyboard_check_pressed(ord("D")) || keyboard_check_pressed(vk_right);
var _confirm = keyboard_check_pressed(vk_enter) || gamepad_button_check_pressed(global.controle, gp_face1);
var _back = keyboard_check_pressed(vk_escape) || gamepad_button_check_pressed(global.controle, gp_face2);

function menu_mouse_over(_mouse_x, _mouse_y, _x, _y, _w, _h) {
    return point_in_rectangle(
        _mouse_x,
        _mouse_y,
        _x - _w * 0.5,
        _y - _h * 0.5,
        _x + _w * 0.5,
        _y + _h * 0.5
    );
}

switch (estado) {
    case MENU_ESTADO.principal:
        var _count = array_length(main_options);

        if (_up) selected_main = (selected_main - 1 + _count) mod _count;
        if (_down) selected_main = (selected_main + 1) mod _count;

        var _bx = _gw * 0.25;
        var _by = _gh * 0.34;
        var _bw = min(390, _gw * 0.34);
        var _bh = 46;
        var _gap = 54;

        for (var _i = 0; _i < _count; _i++) {
            var _yy = _by + _i * _gap;

            if (menu_mouse_over(_mx, _my, _bx, _yy, _bw, _bh)) {
                selected_main = _i;

                if (mouse_check_button_pressed(mb_left)) {
                    _confirm = true;
                }
            }
        }

        if (_confirm) {
            switch (selected_main) {
                case 0: // Continuar
                    var _slot_continue = get_continue_slot();

                    if (_slot_continue != -1) {
                        last_slot = _slot_continue;
                        save_options();
                        global.carrega_jogo(_slot_continue);
                    }
                break;

                case 1: // Novo jogo
                    refresh_saves();
                    selected_slot = clamp(last_slot - 1, 0, 2);
                    confirm_overwrite = false;
                    estado = MENU_ESTADO.novo_slot;
                break;

                case 2: // Carregar
                    refresh_saves();
                    selected_slot = clamp(last_slot - 1, 0, 2);
                    confirm_overwrite = false;
                    estado = MENU_ESTADO.carregar_slot;
                break;

                case 3:
                    estado = MENU_ESTADO.mundos;
                    selected_world = 0;
                break;

                case 4:
                    estado = MENU_ESTADO.opcoes;
                    selected_option = 0;
                break;

                case 5:
                    room_goto(rm_creditos);
                break;

                case 6:
                    game_end();
                break;
            }
        }
    break;

    case MENU_ESTADO.novo_slot:
    case MENU_ESTADO.carregar_slot:
        if (_up) selected_slot = max(0, selected_slot - 1);
        if (_down) selected_slot = min(2, selected_slot + 1);

        var _sx = _gw * 0.5;
        var _sy = _gh * 0.31;
        var _sw = min(760, _gw - 120);
        var _sh = 105;
        var _sgap = 118;

        for (var _i = 0; _i < 3; _i++) {
            var _slot_y = _sy + _i * _sgap;

            if (menu_mouse_over(_mx, _my, _sx, _slot_y, _sw, _sh)) {
                selected_slot = _i;

                if (mouse_check_button_pressed(mb_left)) {
                    _confirm = true;
                }
            }
        }

        if (_back) {
            confirm_overwrite = false;
            estado = MENU_ESTADO.principal;
        }

        if (_confirm) {
            var _slot = selected_slot + 1;
            var _meta = save_meta[selected_slot];

            if (estado == MENU_ESTADO.carregar_slot) {
                if (_meta.exists) {
                    last_slot = _slot;
                    save_options();
                    global.carrega_jogo(_slot);
                }
            }
            else {
                if (_meta.exists && !confirm_overwrite) {
                    confirm_overwrite = true;
                    confirm_slot = _slot;
                }
                else {
                    last_slot = _slot;
                    save_options();
                    global.novo_jogo(_slot);
                }
            }
        }

        if (confirm_overwrite && confirm_slot != selected_slot + 1) {
            confirm_overwrite = false;
        }
    break;

    case MENU_ESTADO.mundos:
        var _wc = array_length(world_options);

        if (_left || _up) selected_world = (selected_world - 1 + _wc) mod _wc;
        if (_right || _down) selected_world = (selected_world + 1) mod _wc;

        var _wx = _gw * 0.5;
        var _wy = _gh * 0.52;
        var _card_w = 190;
        var _card_h = 180;
        var _spacing = 230;

        for (var _i = 0; _i < 3; _i++) {
            var _cx = _wx + (_i - 1) * _spacing;

            if (menu_mouse_over(_mx, _my, _cx, _wy, _card_w, _card_h)) {
                selected_world = _i;

                if (mouse_check_button_pressed(mb_left)) {
                    _confirm = true;
                }
            }
        }

        if (_confirm) {
            switch (selected_world) {
                case 0: room_goto(rm_facil); break;
                case 1: room_goto(rm_hardcore); break;
                case 2: room_goto(rm_construcao); break;
            }
        }

        if (_back) estado = MENU_ESTADO.principal;
    break;

    case MENU_ESTADO.opcoes:
        var _option_count = 4;

        if (_up) selected_option = (selected_option - 1 + _option_count) mod _option_count;
        if (_down) selected_option = (selected_option + 1) mod _option_count;

        // Volume.
        if (selected_option == 0) {
            if (_left) volume_visual = max(0, volume_visual - 0.05);
            if (_right) volume_visual = min(1, volume_visual + 0.05);

            global.volume_mestre = volume_visual;
            audio_master_gain(global.volume_mestre);
        }

        // Fullscreen.
        if (selected_option == 1 && (_left || _right || _confirm)) {
            fullscreen = !fullscreen;
            window_set_fullscreen(fullscreen);
        }

        // Dificuldade.
        if (selected_option == 2) {
            if (_left) global.dificuldade = max(0, global.dificuldade - 1);
            if (_right || _confirm) global.dificuldade = min(2, global.dificuldade + 1);
        }

        // Mouse nas linhas.
        var _ox = _gw * 0.5;
        var _oy = _gh * 0.34;
        var _ow = 560;
        var _oh = 58;

        for (var _i = 0; _i < _option_count; _i++) {
            var _row_y = _oy + _i * 78;

            if (menu_mouse_over(_mx, _my, _ox, _row_y, _ow, _oh)) {
                selected_option = _i;

                if (mouse_check_button_pressed(mb_left)) {
                    if (_i == 0) {
                        volume_visual += 0.10;
                        if (volume_visual > 1) volume_visual = 0;

                        global.volume_mestre = volume_visual;
                        audio_master_gain(global.volume_mestre);
                    }
                    else if (_i == 1) {
                        fullscreen = !fullscreen;
                        window_set_fullscreen(fullscreen);
                    }
                    else if (_i == 2) {
                        global.dificuldade = (global.dificuldade + 1) mod 3;
                    }
                    else if (_i == 3) {
                        save_options();
                        estado = MENU_ESTADO.principal;
                    }
                }
            }
        }

        if ((selected_option == 3 && _confirm) || _back) {
            save_options();
            estado = MENU_ESTADO.principal;
        }
    break;
}

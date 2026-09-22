if (instance_exists(obj_sdash)) {
    var _sdash_check = instance_find(obj_sdash, 0);
    if (_sdash_check.vida <= 0) {
        global.pause_menu.active = false;
        global.pause = false;
        exit;
    }
}

var _inventory_open = false;

if (instance_exists(obj_inventario)) {
    var _inv = instance_find(obj_inventario, 0);
    if (variable_instance_exists(_inv, "inventario")) {
        _inventory_open = _inv.inventario;
    }
}

var _blocking_ui =
    global.dialogo_acontecendo
    || _inventory_open
    || instance_exists(obj_shop_int_1)
    || (
        variable_global_exists("game_state")
        && is_struct(global.game_state)
        && variable_struct_exists(global.game_state.runtime, "modal_ui")
        && string_length(global.game_state.runtime.modal_ui) > 0
    )
    || (
        variable_global_exists("game_state")
        && is_struct(global.game_state)
        && global.game_state.runtime.quest_journal_open
    );

if (keyboard_check_pressed(vk_escape) && !_blocking_ui) {
    if (global.pause_menu.active && pause_page == 1) {
        // ESC dentro de Opcoes volta para o menu de pause, nao fecha o pause inteiro.
        ini_open("config.ini");
        ini_write_real("audio", "volume", global.volume_mestre);
        ini_write_real("video", "fullscreen", pause_fullscreen ? 1 : 0);
        ini_write_real("game", "dificuldade", global.dificuldade);
        ini_write_real("save", "last_slot", global.save_slot);
        ini_close();

        pause_page = 0;
        audio_pause_all();
    }
    else {
        global.pause_menu.active = !global.pause_menu.active;
        pause_page = 0;

        global.pause = global.pause_menu.active;
        global.pause_por_inventario = false;

        if (variable_global_exists("game_state") && is_struct(global.game_state)) {
            global.game_state.runtime.pause = global.pause;
        }

        if (global.pause) {
            pause_volume = global.volume_mestre;
            pause_fullscreen = window_get_fullscreen();
            audio_pause_all();
        }
        else {
            audio_resume_all();
        }
    }
}

if (global.pause_menu.active && !global.dialogo_acontecendo) {
    var _up = keyboard_check_pressed(ord("W")) || keyboard_check_pressed(vk_up);
    var _down = keyboard_check_pressed(ord("S")) || keyboard_check_pressed(vk_down);
    var _left = keyboard_check_pressed(ord("A")) || keyboard_check_pressed(vk_left);
    var _right = keyboard_check_pressed(ord("D")) || keyboard_check_pressed(vk_right);
    var _confirm = keyboard_check_pressed(vk_enter) || gamepad_button_check_pressed(global.controle, gp_face1);

    var _gw = display_get_gui_width();
    var _gh = display_get_gui_height();
    var _mouse_x = device_mouse_x_to_gui(0);
    var _mouse_y = device_mouse_y_to_gui(0);

    var _panel_w = min(760, _gw - 100);
    var _panel_h = min(560, _gh - 90);
    var _panel_x = (_gw - _panel_w) * 0.5;
    var _panel_y = (_gh - _panel_h) * 0.5;

    if (pause_page == 0) {
        var _count = array_length(global.pause_menu.options);

        var _menu_x = _panel_x + 64;
        var _menu_y = _panel_y + 125;

        for (var _mi = 0; _mi < _count; _mi++) {
            var _row_y = _menu_y + _mi * 58;

            if (point_in_rectangle(
                _mouse_x,
                _mouse_y,
                _menu_x - 14,
                _row_y - 12,
                _panel_x + _panel_w * 0.57,
                _row_y + 30
            )) {
                global.pause_menu.selected = _mi;

                if (mouse_check_button_pressed(mb_left)) {
                    _confirm = true;
                }
            }
        }

        if (_up) {
            global.pause_menu.selected = (global.pause_menu.selected - 1 + _count) mod _count;
        }

        if (_down) {
            global.pause_menu.selected = (global.pause_menu.selected + 1) mod _count;
        }

        if (_confirm) {
            switch (global.pause_menu.selected) {
                case 0: // Continuar
                    global.pause_menu.active = false;
                    global.pause = false;

                    if (variable_global_exists("game_state") && is_struct(global.game_state)) {
                        global.game_state.runtime.pause = false;
                    }

                    audio_resume_all();
                break;

                case 1: // Salvar
                    if (variable_global_exists("salva_jogo")) {
                        global.salva_jogo(global.save_slot);
                    }
                break;

                case 2: // Diario
                    if (instance_exists(obj_misson_manager)) {
                        global.pause_menu.active = false;

                        global.game_state.runtime.quest_journal_open = true;
                        global.pause = true;
                        global.game_state.runtime.pause = true;

                        var _manager = instance_find(obj_misson_manager, 0);
                        _manager.journal_pause_owned = true;

                        audio_resume_all();
                    }
                break;

                case 3:
                    pause_page = 1;
                    option_selected = 0;
                    audio_resume_all();
                break;

                case 4: // Salva antes de sair.
                    if (variable_global_exists("salva_jogo")) {
                        global.salva_jogo(global.save_slot);
                    }

                    audio_resume_all();

                    if (variable_global_exists("voltar_menu")) {
                        global.voltar_menu();
                    }
                    else {
                        room_goto(room_menu);
                    }

                    exit;
                break;
            }
        }
    }
    else {
        // Pagina de opcoes.
        var _count_opt = 4;
        var _options_y = _panel_y + 180;

        for (var _oi = 0; _oi < _count_opt; _oi++) {
            var _option_y = _options_y + _oi * 70;

            if (point_in_rectangle(
                _mouse_x,
                _mouse_y,
                _gw * 0.5 - 260,
                _option_y - 12,
                _gw * 0.5 + 260,
                _option_y + 32
            )) {
                option_selected = _oi;

                if (mouse_check_button_pressed(mb_left)) {
                    if (_oi == 0) {
                        pause_volume += 0.10;
                        if (pause_volume > 1) pause_volume = 0;
                        global.volume_mestre = pause_volume;
                        audio_master_gain(global.volume_mestre);
                    }
                    else {
                        _confirm = true;
                    }
                }
            }
        }

        if (_up) option_selected = (option_selected - 1 + _count_opt) mod _count_opt;
        if (_down) option_selected = (option_selected + 1) mod _count_opt;

        if (option_selected == 0) {
            if (_left) pause_volume = max(0, pause_volume - 0.05);
            if (_right) pause_volume = min(1, pause_volume + 0.05);

            global.volume_mestre = pause_volume;
            audio_master_gain(global.volume_mestre);
        }

        if (option_selected == 1 && (_left || _right || _confirm)) {
            pause_fullscreen = !pause_fullscreen;
            window_set_fullscreen(pause_fullscreen);
        }

        if (option_selected == 2) {
            if (_left) global.dificuldade = max(0, global.dificuldade - 1);
            if (_right || _confirm) global.dificuldade = min(2, global.dificuldade + 1);
        }

        if ((option_selected == 3 && _confirm) || keyboard_check_pressed(vk_escape)) {
            ini_open("config.ini");
            ini_write_real("audio", "volume", global.volume_mestre);
            ini_write_real("video", "fullscreen", pause_fullscreen ? 1 : 0);
            ini_write_real("game", "dificuldade", global.dificuldade);
            ini_write_real("save", "last_slot", global.save_slot);
            ini_close();

            pause_page = 0;
            audio_pause_all();
        }
    }

    bg_alpha = min(bg_alpha + 0.08, 0.78);
}
else {
    bg_alpha = max(bg_alpha - 0.08, 0);
}

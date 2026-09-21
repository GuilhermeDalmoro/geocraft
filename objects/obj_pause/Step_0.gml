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
    || instance_exists(obj_fornalha_ui)
    || instance_exists(obj_shop_int_1)
    || (
        variable_global_exists("game_state")
        && is_struct(global.game_state)
        && global.game_state.runtime.quest_journal_open
    );

if (keyboard_check_pressed(vk_escape) && !_blocking_ui) {
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

if (global.pause_menu.active && !global.dialogo_acontecendo) {
    var _up = keyboard_check_pressed(ord("W")) || keyboard_check_pressed(vk_up);
    var _down = keyboard_check_pressed(ord("S")) || keyboard_check_pressed(vk_down);
    var _left = keyboard_check_pressed(ord("A")) || keyboard_check_pressed(vk_left);
    var _right = keyboard_check_pressed(ord("D")) || keyboard_check_pressed(vk_right);
    var _confirm = keyboard_check_pressed(vk_enter) || gamepad_button_check_pressed(global.controle, gp_face1);

    if (pause_page == 0) {
        var _count = array_length(global.pause_menu.options);

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

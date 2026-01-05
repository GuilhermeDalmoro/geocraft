// obj_pause Step
if instance_exists(obj_sdash){
	if(obj_sdash.vida <= 0){
			instance_destroy();
	}
}

if (keyboard_check_released(vk_escape)) {
    if (!global.dialogo_acontecendo && !obj_inventario.inventario) {
        global.pause_menu.active = !global.pause_menu.active;
        global.pause = global.pause_menu.active;
        global.pause_por_inventario = false;
        if (global.pause) audio_pause_all(); else audio_resume_all();
    }
}

// Navegação no menu
if (global.pause_menu.active && !global.dialogo_acontecendo) {
    if (keyboard_check_pressed(vk_up)) global.pause_menu.selected = max(0, global.pause_menu.selected - 1);
    if (keyboard_check_pressed(vk_down)) global.pause_menu.selected = min(1, global.pause_menu.selected + 1);
    if (keyboard_check_pressed(vk_enter)) {
        switch (global.pause_menu.selected) {
            case 0: // Continuar
                global.pause_menu.active = false;
                global.pause = false;
                audio_resume_all();
                break;
            case 1: // Menu Principal
                room_goto(room_menu); // Ajuste o nome da room do menu
                global.pause_menu.active = false;
                global.pause = false;
                audio_resume_all();
                break;
        }
    }
    
    bg_alpha = min(bg_alpha + 0.05, 0.6); // Fundo mais leve
} else {
    bg_alpha = max(bg_alpha - 0.05, 0);
}
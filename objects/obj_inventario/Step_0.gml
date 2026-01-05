if (instance_exists(obj_sdash)) {
    if (!obj_sdash.active) exit;
     //if (obj_dialogo.inicializar)
        if (keyboard_check_pressed(ord("E")) || gamepad_button_check_pressed(global.controle, gp_face4)) && global.dialogo_acontecendo = false{
            inventario = !inventario;
            global.pause = inventario;
            global.pause_por_inventario = inventario;
            tocar_som_efeito(snd_blip_2, 8, 1)
        }
} else {
    inventario = false;
    global.pause_por_inventario = false;
}
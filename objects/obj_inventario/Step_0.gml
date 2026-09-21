if (instance_exists(obj_sdash)) {
    if (!obj_sdash.active) exit;

    var _toggle_inv =
        keyboard_check_pressed(ord("E"))
        || gamepad_button_check_pressed(global.controle, gp_face4);

    if (_toggle_inv && global.dialogo_acontecendo == false) {
        inventario = !inventario;
        global.pause = inventario;
        global.pause_por_inventario = inventario;
        tocar_som_efeito(snd_blip_2, 1, 1);
    }
} else {
    inventario = false;
    global.pause_por_inventario = false;
}

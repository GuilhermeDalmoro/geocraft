if (instance_number(obj_controle_hud) > 1) {
    instance_destroy();
    exit;
}

if (!variable_global_exists("controle")) {
    global.controle = -1;
}

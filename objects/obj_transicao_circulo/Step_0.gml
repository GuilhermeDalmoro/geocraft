if (!iniciado) exit;

gui_w = display_get_gui_width();
gui_h = display_get_gui_height();

if (!surface_exists(surface_trans)) {
    surface_trans = surface_create(gui_w, gui_h);
}

switch (estado) {
    case 1: // Fechando
        raio = lerp(raio, 0, 0.09);
        if (raio < 4) {
            // Troca de sala quando a tela está praticamente toda preta
            room_goto(sala);
            estado = 2;
        }
        break;
        
    case 2:
    if (instance_exists(obj_sdash)) {
        obj_sdash.x = destino_x;
        obj_sdash.y = destino_y;
        
        // Snap forte na câmera pra evitar qualquer pulinho residual
        with (camera_sdash) {
            x = obj_sdash.x;
            y = obj_sdash.y;
            // Se tiver zoom ou offset, resete aqui também
            cam_w_atual = cam_w_alvo;
            cam_h_atual = cam_h_alvo;
        }
    }
    raio = 1024;   // reseta pra abrir
    estado = 3;
    break;
        
    case 3: // Abrindo
        raio = lerp(raio, 0, 0.11);
        if (raio < 1) {
            with (obj_sdash) active = true;
            iniciado = false;
            estado = 0;
            instance_destroy();   // some depois de abrir
        }
        break;
}
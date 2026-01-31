if (!instance_exists(obj_sdash)) exit;

// distância
var _dist = point_distance(x, y, obj_sdash.x, obj_sdash.y);

// abrir / fechar UI
if (_dist <= dist_interacao && keyboard_check_pressed(ord("F"))) {
    ui_aberta = !ui_aberta;

    if (ui_aberta) {
        espiral_atual = 0;
        ponteiro_ang = 0;
        pode_parar = true;
        completo = false;
        quase_acerto = false;

        for (var i = 0; i < total_espirais; i++) {
            nota_frame[i] = irandom(4);
            nota_ang[i]   = random_range(0, 360);
            nota_dist[i]  = random_range(18, 30);
        }
    }
}

// fecha se afastar
if (_dist > dist_interacao + 8) ui_aberta = false;

// animação UI
ui_anim = lerp(ui_anim, ui_aberta ? 1 : 0, 0.15);

// ===== MINIGAME =====
if (ui_aberta && !completo) {

    // gira ponteiro
    if (pode_parar) {
        ponteiro_ang += ponteiro_vel[espiral_atual];
        if (ponteiro_ang >= 360) ponteiro_ang -= 360;
    } else {
        tempo_erro--;
        if (tempo_erro <= 0) pode_parar = true;
    }

    // input
    if (keyboard_check_pressed(vk_space) && pode_parar) {

        var ang_real = ponteiro_ang + 90;
        var erro = angle_difference(ang_real, nota_ang[espiral_atual]);

        quase_acerto = false;

        if (abs(erro) <= erro_permitido[espiral_atual]) {
            // ACERTO
            espiral_atual++;
            ponteiro_ang = 0;

            if (espiral_atual >= total_espirais) {
                completo = true;
                global.jukebox_sintonizada = true;
            
                // inicia animação do toca-disco
                toca_estado = 1;
            }

        }
        else if (abs(erro) <= erro_permitido[espiral_atual] + 15) {
            // QUASE ACERTO
            quase_acerto = true;
            pode_parar = false;
            tempo_erro = room_speed * 0.5;
        }
        else {
            // ERRO TOTAL
            pode_parar = false;
            tempo_erro = room_speed * 1;
        }
    }
}


// ===== ANIMAÇÃO DO TOCA-DISCO =====
if (completo) {

    // posição base (lado direito do fundo)
    var gw = display_get_gui_width();
    var gh = display_get_gui_height();

    toca_x = gw * 0.78;
    toca_y = gh * 0.52;

    switch (toca_estado) {

        case 1: // aparece
            toca_alpha = lerp(toca_alpha, 1, 0.05);
            if (toca_alpha > 0.95) {
                toca_estado = 2;

                // inicia disco fora
                disco_x = toca_x;
                disco_y = toca_y - 80;
                disco_alpha = 0;
            }
        break;

        case 2: // disco entrando
            disco_x = lerp(disco_x, toca_x, 0.03);
            disco_y = lerp(disco_y, toca_y, 0.03);
            disco_alpha = lerp(disco_alpha, 1, 0.04);

            if (point_distance(disco_x, disco_y, toca_x, toca_y) < 2) {
                toca_estado = 3;
            }
        break;

        case 3: // agulha descendo
            agulha_ang = lerp(agulha_ang, agulha_target, 0.04);
            if (abs(agulha_ang - agulha_target) < 1) {
                toca_estado = 4;
            }
        break;

        case 4: // tocando
            disco_ang += 0.6;
        break;
    }
}

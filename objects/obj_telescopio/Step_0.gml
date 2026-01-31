// Step Event – obj_telescopio (VERSÃO FINAL – colisão precisa, GMDs morrem SÓ NO HIT!)

if (!instance_exists(obj_sdash)) exit;

// Distância e interação
var _dist = point_distance(x, y, obj_sdash.x, obj_sdash.y);

if (_dist <= dist_interacao && keyboard_check_pressed(ord("F"))) {
    ui_aberta = !ui_aberta;
}

if (_dist > dist_interacao + 8) {
    ui_aberta = false;
}

// Rotação suave do telescópio
if (ui_aberta) {
    ang_alvo = point_direction(x, y, mouse_x, mouse_y);
    ang_atual = lerp(ang_atual, ang_alvo, vel_suave);
    image_angle = ang_atual;
}

// Animação suave da UI
if (ui_aberta) {
    ui_alpha = lerp(ui_alpha, 1, 0.18);
    ui_scale = lerp(ui_scale, 1, 0.16);
} else {
    ui_alpha = lerp(ui_alpha, 0, 0.25);
    ui_scale = lerp(ui_scale, 0, 0.20);
}

// Mouse sobre visão + cursor mira
if (ui_aberta && ui_alpha > 0.1) {
    var mx = device_mouse_x_to_gui(0);
    var my = device_mouse_y_to_gui(0);
    
    var left   = visao_x + (visao_w * (1 - ui_scale)) / 2;
    var top    = visao_y + (visao_h * (1 - ui_scale)) / 2;
    var right  = left + visao_w * ui_scale;
    var bottom = top  + visao_h * ui_scale;
    
    mouse_sobre_visao = (mx >= left && mx <= right && my >= top && my <= bottom);
    
    if (mouse_sobre_visao) {
        cursor_sprite = spr_mira;
    } else {
        cursor_sprite = cursor_sprite_antigo;
    }
} else {
    mouse_sobre_visao = false;
    cursor_sprite = cursor_sprite_antigo;
}

// Calcula posição/tamanho da visão (sempre!)
visao_draw_x = visao_x + (visao_w * (1 - ui_scale)) / 2;
visao_draw_y = visao_y + (visao_h * (1 - ui_scale)) / 2;
visao_draw_w = visao_w * ui_scale;
visao_draw_h = visao_h * ui_scale;

// MINI-JOGO DA JUKEBOX
if (ui_aberta && global.jukebox_sintonizada == true) {
    // Spawn GMDs no centro da visão
    spawn_timer++;
    if (spawn_timer >= spawn_interval && array_length(inimigos) < max_inimigos) {
        spawn_timer = 0;
        
        // Spawn sempre no centro
        var centro_x = visao_draw_x + visao_draw_w / 2;
        var centro_y = visao_draw_y + visao_draw_h / 2;
        
        var vx = random_range(-1.5, 1.5);
        var vy = random_range(-1.5, 1.5);
        
        array_push(inimigos, {
            x: centro_x,
            y: centro_y,
            vx: vx,
            vy: vy,
            w: sprite_get_width(spr_gmd) * 0.7,
            h: sprite_get_height(spr_gmd) * 0.7,
            image_index: 0,
            image_speed: 0.15
        });
    }
    
    // Move GMDs + rebate nas bordas
    for (var i = array_length(inimigos) - 1; i >= 0; i--) {
        var gmd = inimigos[i];
        
        gmd.x += gmd.vx;
        gmd.y += gmd.vy;
        
        // Limites internos
        var esq   = visao_draw_x + 12;
        var dir   = visao_draw_x + visao_draw_w - 12 - gmd.w;
        var cima  = visao_draw_y + 12;
        var baixo = visao_draw_y + visao_draw_h - 12 - gmd.h;
        
        // Rebate suave
        if (gmd.x < esq)   { gmd.x = esq;   gmd.vx = -gmd.vx * 0.85; }
        if (gmd.x > dir)   { gmd.x = dir;   gmd.vx = -gmd.vx * 0.85; }
        if (gmd.y < cima)  { gmd.y = cima;  gmd.vy = -gmd.vy * 0.85; }
        if (gmd.y > baixo) { gmd.y = baixo; gmd.vy = -gmd.vy * 0.85; }
        
        // Balanço fofo + animação
        gmd.vx += sin(current_time * 0.001 + i) * 0.02;
        gmd.vy += cos(current_time * 0.0015 + i) * 0.015;
        gmd.image_index += gmd.image_speed;
        if (gmd.image_index >= sprite_get_number(spr_gmd)) gmd.image_index = 0;
    }
    
    // Tiro de nota com botão DIREITO
    if (mouse_check_button_pressed(mb_left) && mouse_sobre_visao) {
        var mx = device_mouse_x_to_gui(0);
        var my = device_mouse_y_to_gui(0);
        
        array_push(notas, {
            x: mx,
            y: my,
            vx: 10 * ui_scale,
            vy: 0,
            w: sprite_get_width(spr_notas) * 0.8,
            h: sprite_get_height(spr_notas) * 0.8,
            image_index: 0,
            image_speed: 0.3
        });
    }
    
    // Move notas + animação + colisão EXATA
    for (var i = array_length(notas) - 1; i >= 0; i--) {
        var nota = notas[i];
        
        nota.x += nota.vx;
        nota.y += nota.vy;
        
        // Remove se saiu
        if (nota.x > visao_draw_x + visao_draw_w + 50) {
            array_delete(notas, i, 1);
            continue;
        }
        
        // Anima nota
        nota.image_index += nota.image_speed;
        if (nota.image_index >= sprite_get_number(spr_notas)) nota.image_index = 0;
        
        // Colisão: SÓ QUANDO ENCOSTAR MESMO
        for (var j = array_length(inimigos) - 1; j >= 0; j--) {
            var gmd = inimigos[j];
            
            var nota_left   = nota.x - nota.w / 2;
            var nota_right  = nota.x + nota.w / 2;
            var nota_top    = nota.y - nota.h / 2;
            var nota_bottom = nota.y + nota.h / 2;
            
            var gmd_left   = gmd.x - gmd.w / 2;
            var gmd_right  = gmd.x + gmd.w / 2;
            var gmd_top    = gmd.y - gmd.h / 2;
            var gmd_bottom = gmd.y + gmd.h / 2;
            
            if (nota_right > gmd_left && nota_left < gmd_right &&
                nota_bottom > gmd_top && nota_top < gmd_bottom) {
                
                // HIT REAL! GMD some + nota some
                array_delete(inimigos, j, 1);
                array_delete(notas, i, 1);
                
                with (camera_sdash) {
                    scr_screen_shake(10, 20);	
                }
                
                // repeat(8) { instance_create_depth(gmd.x, gmd.y, -10, obj_brilho); }
                // audio_play_sound(snd_pling_hit, 10, false);
                
                break;
            }
        }
    }
} else {
    // Limpa tudo ao fechar UI
    inimigos = [];
    notas = [];
    spawn_timer = 0;
}
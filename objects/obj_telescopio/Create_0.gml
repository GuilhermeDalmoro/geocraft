// ===== INTERAÇÃO =====
ui_aberta = false;
dist_interacao = 24;

// ===== ANIMAÇÃO =====
ui_anim = 0;                // 0 = fechado, 1 = aberto (usaremos lerp)
ui_alpha = 0;               // controle de transparência suave
ui_scale = 0;               // escala crescendo na entrada

// ===== ROTAÇÃO =====
ang_atual = image_angle;
ang_alvo = image_angle;
ang_min = -90;
ang_max = 90;
vel_suave = 0.05;

// ===== VISOR DA MASMORRA =====
spr_visao = spr_angulo_masmorra;     // sua sprite 670x671
visao_w   = sprite_get_width(spr_visao);
visao_h   = sprite_get_height(spr_visao);

// Posição central na tela (GUI)
visao_x = (display_get_gui_width()  - visao_w) div 2;
visao_y = (display_get_gui_height() - visao_h) div 2 - 20;  // um pouquinho pra cima

// Controle de mouse sobre a sprite
mouse_sobre_visao = false;
cursor_sprite_antigo = cursor_sprite;  // guarda o cursor normal

inimigos = [];           // array de structs pros GMDs
notas = [];              // array de structs pras notas musicais
spawn_timer = 0;         // timer pra spawnar inimigos
spawn_interval = 120;    // spawna a cada ~2s (60fps)
max_inimigos = 5;        // max 5 GMDs na tela pra não lagar

spr_inimigo = spr_gmd;   // sprite do inimigo
spr_nota = spr_notas;    // sprite da nota musical

// Variáveis pra posição/tamanho da visão (calculadas no Step e usadas em Draw/Step)
visao_draw_x   = 0;
visao_draw_y   = 0;
visao_draw_w   = 0;
visao_draw_h   = 0;
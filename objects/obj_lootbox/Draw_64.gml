if (!aberto) exit;

var gui_w = display_get_gui_width();
var gui_h = display_get_gui_height();
var loot_x = (gui_w - loot_w) div 2;
var loot_y = (gui_h - loot_h) div 2;

// Fundo principal do baú
draw_sprite_ext(spr_hud_loot, 0, loot_x, loot_y, escala, escala, 0, c_white, 1);

// Título épico
draw_set_font(fnt_geocraft);
draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_set_color(c_white);
draw_text(gui_w div 2, loot_y + 50, "Escolha seu destino...");

// As 3 opções – agora com layout mais confortável
for (var i = 0; i < array_length(opcoes); i++) {
    var ins = opcoes[i];
    var _x = loot_x + 80 + i * 180;       // centro do slot
    var _y = loot_y + 120;
    
    // Slot de fundo (18×18 escalado ×4 = 72×72)
    draw_sprite_ext(spr_slot, 0, _x, _y, escala, escala, 0, c_white, 1);
    
    // Ícone da insígnia (15×15 → escalado ×4 = 60×60)
    // centralizado dentro do slot
    draw_sprite_ext(spr_insignia_1, ins.frame_index, _x, _y, escala, escala, 0, c_white, 1);
    
    // Glow sutil na cor da insígnia (opcional – fica muito fofo)
    gpu_set_blendmode(bm_add);
    draw_sprite_ext(spr_insignia_1, ins.frame_index, _x, _y, escala * 1.15, escala * 1.15, 0, ins.cor, 0.25);
    gpu_set_blendmode(bm_normal);
    
    // Nome da insígnia (fonte pequena + cor)
    draw_set_font(fonte);                      // fnt_dialogo_small – 13px
    draw_set_color(ins.cor);
    draw_set_halign(fa_center);
    draw_set_valign(fa_bottom);
    draw_text(_x, _y - 36, ins.nome);          // acima do slot
    
    // Estrelas (logo abaixo do slot)
    for (var s = 0; s < 5; s++) {              // sempre mostra 5 espaços
        var star_x = _x - 40 + s * 20;         // 5 estrelas espaçadas em 20 px
        var star_y = _y + 48;
        var alpha = (s < estrelas_reveladas) ? 1 : 0.3;
        var cor_star = (s < estrelas_reveladas) ? c_yellow : c_dkgray;
        draw_sprite_ext(spr_star, 0, star_x, star_y, 1.6, 1.6, 0, cor_star, alpha);
    }
    
    // Descrição + efeito (aparece só depois de revelar estrelas)
    if (estrelas_reveladas >= estrelas_total) {
        draw_set_font(fonte);                  // mesma fonte pequena
        draw_set_color(c_white);
        draw_set_halign(fa_center);
        draw_set_valign(fa_top);
        draw_text_ext(_x, _y + 70, ins.desc + "\n" + ins.efeito_nome, 16, 160);
    }
}

// Instrução inferior (só quando pode clicar)
if (estrelas_reveladas >= estrelas_total && !escolha_feita) {
    draw_set_font(fonte);
    draw_set_color(c_yellow);
    draw_set_halign(fa_center);
    draw_set_valign(fa_bottom);
    draw_text(gui_w div 2, gui_h - 40, "Clique em uma para escolher seu caminho!");
}
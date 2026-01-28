var gw = display_get_gui_width();
var gh = display_get_gui_height();

// Posição base
var cx = gw * 0.5;
var cy = gh * 0.15;

// Espaçamentos
var sombra_offset = 4;
var distancia_linhas = 36;

// Configura alinhamento
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// ===== LINHA SUPERIOR =====
draw_set_alpha(alpha);
draw_sprite_ext(
    spr_efeito_intro,
    0,
    cx,
    cy - distancia_linhas,
    6, 6,
    0,
    c_white,
    alpha
);

// ===== LINHA INFERIOR (INVERTIDA) =====
draw_sprite_ext(
    spr_efeito_intro,
    0,
    cx,
    cy + distancia_linhas,
    6, -6, // INVERTENDO NO Y
    0,
    c_white,
    alpha
);

// ===== SOMBRA DO TEXTO =====
draw_set_font(fonte);
draw_set_color(c_black);
draw_set_alpha(alpha * 0.6);

draw_text(
    cx + sombra_offset,
    cy + sombra_offset,
    texto
);

// ===== TEXTO PRINCIPAL =====
draw_set_color(c_white);
draw_set_alpha(alpha);

draw_text(
    cx,
    cy,
    texto
);

// ===== RESET =====
draw_set_alpha(1);
draw_set_color(c_white);
draw_set_font(-1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

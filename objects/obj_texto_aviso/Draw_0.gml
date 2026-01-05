draw_set_alpha(alpha);
draw_set_color(c_white);
draw_set_font(fnt_dialogo_small); 
draw_set_halign(fa_center); // Centraliza horizontalmente
draw_set_valign(fa_middle); // Centraliza verticalmente
draw_text(x, y, text);
draw_set_halign(fa_left); // Reseta alinhamento
draw_set_valign(fa_top); // Reseta alinhamento
draw_set_alpha(1); // Reseta o alfa
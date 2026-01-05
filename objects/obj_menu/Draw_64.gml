draw_set_font(fnt_dialogo); // Assuma uma font pixelada
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_set_color(c_white);

// Fundo básico (opcional, mas como é um obj só, desenhe se quiser)
//draw_rectangle_color(0, 0, room_width, room_height, c_black, c_black, c_black, c_black, false); // Preto simples

switch (estado) {
    case menu_estado.principal:
        // Desenha as 4 opções
        var ops = ["JOGAR (Modo história)", "MUNDOS", "OPCOES", "SAIR"];
        for (var i = 0; i < 4; i++) {
            var op_x = room_width / 2;
            var op_y = op_y_inicio + i * op_espaco;
            if (hover == i) {
                draw_set_color(c_yellow); // Hover amarelo
                draw_text_transformed(op_x, op_y, ops[i], 1.2, 1.2, 0); // Scale up
            } else {
                draw_set_color(c_white);
                draw_text(op_x, op_y, ops[i]);
            }
        }
        break;
    
    case menu_estado.mundos:
        // Desenha 3 sprites lado a lado
        draw_sprite(spr_mundo_facil, 0, mundo_x1, mundo_y);
        draw_sprite(spr_mundo_hardcore, 0, mundo_x2, mundo_y);
        draw_sprite(spr_mundo_construcao, 0, mundo_x3, mundo_y);
        
        // Labels abaixo (opcional)
        draw_text(mundo_x1, mundo_y + 80, "Fácil");
        draw_text(mundo_x2, mundo_y + 80, "Hardcore");
        draw_text(mundo_x3, mundo_y + 80, "Construção");
        
        // Hover: Scale up
        if (hover == 0) draw_sprite_ext(spr_mundo_facil, 0, mundo_x1, mundo_y, 1.2, 1.2, 0, c_white, 1);
        if (hover == 1) draw_sprite_ext(spr_mundo_hardcore, 0, mundo_x2, mundo_y, 1.2, 1.2, 0, c_white, 1);
        if (hover == 2) draw_sprite_ext(spr_mundo_construcao, 0, mundo_x3, mundo_y, 1.2, 1.2, 0, c_white, 1);
        break;
    
    case menu_estado.opcoes:
        // Desenha configs
        // Volume: Label + slider
		 var vol_x1 = room_width / 2 - 200;
        var vol_y = op_y_inicio;
        var vol_x2 = room_width / 2 + 200;
		
		var fs_x = room_width / 2;
        var fs_y = op_y_inicio + op_espaco;
		
		var dif_x = room_width / 2;
        var dif_y = op_y_inicio + 2 * op_espaco;
		
	    // Vibração: Toggle exemplo
        var vib_x = room_width / 2;
        var vib_y = op_y_inicio + 3 * op_espaco;
		
        draw_text(room_width / 2, op_y_inicio - 30, "Volume");
        draw_rectangle(vol_x1, op_y_inicio - 5, vol_x2, op_y_inicio + 5, true); // Barra
     //   draw_circle(vol_x1 + volume * (vol_x2 - vol_x1), op_y_inicio, 10, false); // Knob
        
        // Fullscreen: Label + toggle
        draw_text(room_width / 2, fs_y, "Fullscreen: " + (fullscreen ? "Sim" : "Não"));
        
        // Dificuldade: Label + valor
        var dif_txt = ["Fácil", "Normal", "Hard"];
        draw_text(room_width / 2, dif_y, "Dificuldade: " + dif_txt[global.dificuldade]);
        
        // Vibração: Label + toggle
        draw_text(room_width / 2, vib_y, "Vibração: " + (vibracao ? "Sim" : "Não"));
        break;
}

draw_set_font(-1); // Assuma uma font pixelada
draw_set_halign(-1);
draw_set_valign(-1);
draw_set_color(c_white);
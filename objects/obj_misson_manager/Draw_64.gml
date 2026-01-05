if (bg_alpha > 0) {
    draw_set_alpha(bg_alpha);
    
    // Desenha fundo e moldura (barra no topo)
    var _x = 0;
    var _y = 10;
    var _width = 1280;
    var _height = 60;
    draw_sprite_stretched(spr_mission_bg, 0, _x + 5, _y + 5, _width - 10, _height - 10);
    draw_sprite_stretched(spr_mission_frame, floor(frame_anim), _x, _y, _width, _height);
    
    // Desenha texto
    draw_set_font(fnt_desc_inventario);
    draw_set_color(c_black);
    draw_text(_x + 20, _y + 6, "Missões Ativas"); // Sombra
    draw_set_color(c_white);
    draw_text(_x + 18, _y + 4, "Missões Ativas"); // Título
    
    // Posições fixas pra missões ativas
    var _positions = [200, 550, 900, 1250]; // X fixos pra até 4 missões
    var _active_count = 0;
    for (var i = 0; i < array_length(global.missions); i++) {
        if (global.missions[i].status == "active" && _active_count < array_length(_positions)) {
            var _x_pos = _positions[_active_count];
            var _icon_pulse = 1 + sin(current_time * 0.005 + _active_count) * 0.1;
            draw_sprite_ext(spr_mission_icon, 0, _x_pos, _y + 20, _icon_pulse, _icon_pulse, 0, c_white, 1);
            draw_set_color(c_black);
            draw_text(_x_pos + 18, _y + 10, global.missions[i].name); // Sombra nome
            
            // Exibe todos os objetivos dinamicamente
            var _progress_text = "";
            var _progress = global.missions[i].progress;
            var _targets = variable_struct_exists(global.missions[i], "targets") ? global.missions[i].targets : [global.missions[i].target];
            for (var j = 0; j < array_length(global.missions[i].objectives); j++) {
                _progress_text += (j > 0 ? " | " : "") + global.missions[i].objectives[j] + ": " + 
                                string(_progress[j]) + "/" + string(_targets[j % array_length(_targets)]);
            }
            draw_text(_x_pos + 18, _y + 30, _progress_text); // Sombra progresso
            
            draw_set_color(c_white);
            draw_text(_x_pos + 16, _y + 8, global.missions[i].name); // Nome
            draw_text(_x_pos + 16, _y + 28, _progress_text); // Progresso
            
            _active_count++;
        }
    }
    
    draw_set_alpha(1);
}
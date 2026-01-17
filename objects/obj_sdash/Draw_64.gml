// Draw GUI do obj_sdash – desenha o fade preto por cima de tudo
if (fade_alpha > 0) {
    var gw = display_get_gui_width();
    var gh = display_get_gui_height();
    
    draw_set_alpha(fade_alpha);
    draw_rectangle_color(0, 0, gw, gh, c_black, c_black, c_black, c_black, false);
    draw_set_alpha(1);
}
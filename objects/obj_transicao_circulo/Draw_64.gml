if (!iniciado || estado == 0) exit;

if (surface_exists(surface_trans)) {
    surface_set_target(surface_trans);
    draw_clear_alpha(c_black, 0);
    
    draw_rectangle_color(0, 0, gui_w, gui_h, c_black, c_black, c_black, c_black, false);
    
    gpu_set_blendmode(bm_subtract);
    draw_circle(gui_w/2, gui_h/2, raio, false);
    
    surface_reset_target();
    gpu_set_blendmode(bm_normal);
    
    draw_surface(surface_trans, 0, 0);
}
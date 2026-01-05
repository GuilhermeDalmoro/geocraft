if (t == true) {
    if (t_raio <= 0.1) {
        room_goto(sala);
        t = false;
    }
    
    if (surface_exists(surface_t)) {
        obj_sdash.active = false;
        surface_set_target(surface_t);
        draw_clear_alpha(c_black, 0);
        
        
        var gui_w = display_get_gui_width();
        var gui_h = display_get_gui_height();
        draw_rectangle_color(0, 0, gui_w, gui_h, c_black, c_black, c_black, c_black, false);
        
        gpu_set_blendmode(bm_subtract);
        
        t_raio = lerp(t_raio, 0, 0.08);
        draw_set_color(c_white);
        
        draw_circle(gui_w / 2, gui_h / 2, t_raio, false);
        
        surface_reset_target();
        gpu_set_blendmode(bm_normal);
    } else {
        var gui_w = display_get_gui_width();
        var gui_h = display_get_gui_height();
        surface_t = surface_create(gui_w, gui_h);

    }
    draw_surface(surface_t, 0, 0);
}
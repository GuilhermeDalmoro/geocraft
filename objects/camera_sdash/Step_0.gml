if instance_exists(obj_sdash) {

    // ============================
    // POSIÇÃO BASE (seguir sdash)
    // ============================
    var alvo_x = obj_sdash.x;
    var alvo_y = obj_sdash.y;

    // ============================
    // SHIFT + MOUSE (OLHAR ADIANTE)
    // ============================
    if keyboard_check(vk_shift) {

        var mx = device_mouse_x(0);
        var my = device_mouse_y(0);

        var dir = point_direction(alvo_x, alvo_y, mx, my);
        var dist = min(point_distance(alvo_x, alvo_y, mx, my), offset_max);

        var off_x_alvo = lengthdir_x(dist, dir);
        var off_y_alvo = lengthdir_y(dist, dir);

        offset_x = lerp(offset_x, off_x_alvo, vel_lerp_offset);
        offset_y = lerp(offset_y, off_y_alvo, vel_lerp_offset);

        // ============================
        // SHIFT + SCROLL (ZOOM)
        // ============================
        var scroll = mouse_wheel_up() - mouse_wheel_down();
        if (scroll != 0) {
            cam_w_alvo = clamp(cam_w_alvo - scroll * zoom_step, zoom_min, zoom_max);
            cam_h_alvo = cam_w_alvo * (cam_h_atual / cam_w_atual);
        }

    } else {
        // volta suavemente pro centro
        offset_x = lerp(offset_x, 0, vel_lerp_offset);
        offset_y = lerp(offset_y, 0, vel_lerp_offset);
    }

    // ============================
    // APLICA POSIÇÃO FINAL
    // ============================
    x = lerp(x, alvo_x + offset_x, vel_lerp_cam);
    y = lerp(y, alvo_y + offset_y, vel_lerp_cam);

} else {
    global.pause = true;
}

// ============================
// SCREEN SHAKE
// ============================
if (shake_forca != 0) {
    x += random_range(-shake_forca, shake_forca);
    y += random_range(-shake_forca, shake_forca);
}

// ============================
// ZOOM SUAVE
// ============================
cam_w_atual = lerp(cam_w_atual, cam_w_alvo, vel_lerp_cam);
cam_h_atual = lerp(cam_h_atual, cam_h_alvo, vel_lerp_cam);

camera_set_view_size(cam, cam_w_atual, cam_h_atual);

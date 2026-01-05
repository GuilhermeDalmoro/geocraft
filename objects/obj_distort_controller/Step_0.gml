/// obj_distort_controller Step
if (!global.distort_enabled) exit;

for (var i = ds_list_size(dist_waves) - 1; i >= 0; i--) {
    var w = dist_waves[| i];
    w[3] += w[5]; // radius += growth_speed (index 3 é radius)
    w[4] -= 0.01; // alpha decay (index 4)
    if (w[3] > w[2] || w[4] <= 0) {
        // remove
        ds_list_delete(dist_waves, i);
    } else {
        dist_waves[| i] = w; // escreve de volta
    }
}

// demo: aperta espaço para criar uma onda no mouse
if (keyboard_check_pressed(vk_space)) {
    var mx = device_mouse_x_to_gui(0);
    var my = device_mouse_y_to_gui(0);
    // [x, y, max_radius, radius, alpha, growth_speed]
    var neww = array_create(6);
    neww[0] = mx;
    neww[1] = my;
    neww[2] = max(room_width, room_height) * 0.6;
    neww[3] = 1;
    neww[4] = 1.0;
    neww[5] = 10; // velocidade de expansão (pixels/step)
    ds_list_add(dist_waves, neww);
}

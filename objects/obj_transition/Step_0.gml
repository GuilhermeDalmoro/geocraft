if (fade_in) {
    alpha = min(1, alpha + fade_speed);

    if (alpha >= 1) {
        fade_in = false;

        if (target_room != noone && room != target_room) {
            room_goto(target_room);
            exit;
        }
    }
}
else {
    if (instance_exists(obj_sdash)) {
        obj_sdash.x = target_x;
        obj_sdash.y = target_y;
    }

    if (variable_global_exists("game_state") && is_struct(global.game_state)) {
        gc_world_room_entered(room_get_name(room));
    }

    alpha = max(0, alpha - fade_speed);

    if (alpha <= 0) {
        instance_destroy();
    }
}

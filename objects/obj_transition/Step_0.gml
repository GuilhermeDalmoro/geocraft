if (instance_exists(obj_sdash)) {
    var _transition_sdash = instance_find(obj_sdash, 0);
    _transition_sdash.active = false;
}

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
        var _sdash = instance_find(obj_sdash, 0);
        _sdash.x = target_x;
        _sdash.y = target_y;
    }

    if (variable_global_exists("game_state") && is_struct(global.game_state)) {
        gc_world_room_entered(room_get_name(room));
        gc_world_restore_room(room_get_name(room));
    }

    alpha = max(0, alpha - fade_speed);

    if (alpha <= 0) {
        if (instance_exists(obj_sdash)) {
            var _sdash_ready = instance_find(obj_sdash, 0);
            _sdash_ready.active = true;
        }

        instance_destroy();
    }
}

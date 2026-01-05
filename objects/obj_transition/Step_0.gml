if (fade_in) {
    alpha += fade_speed;
    if (alpha >= 1) {
        // Fade out completo: muda room e posiciona Sdash
        room_goto(target_room);
        if (instance_exists(obj_sdash)) {
            obj_sdash.x = target_x;
            obj_sdash.y = target_y;
        }
        fade_in = false; // Agora fade in na nova room
    }
} else {
    alpha -= fade_speed;
    if (alpha <= 0) {
        instance_destroy(); // Missão cumprida!
    }
}
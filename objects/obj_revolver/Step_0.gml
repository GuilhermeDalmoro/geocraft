if (instance_exists(obj_sdash)) {
    x = obj_sdash.x - 20;
    y = obj_sdash.y;
}

image_angle = point_direction(x, y, mouse_x, mouse_y);

if (mouse_check_button_pressed(mb_left) && pode_atirar) {
    var _tiro = instance_create_layer(x, y, "Instances", obj_tiro_revolver);
    _tiro.speed = 4;
    _tiro.image_xscale = 3;
    _tiro.image_yscale = 3;
    _tiro.direction = image_angle;

    scr_screen_shake(12, 12);
    // audio_play_sound(snd_tiro, 8, false);

    pode_atirar = false;
    alarm[0] = 60;
}

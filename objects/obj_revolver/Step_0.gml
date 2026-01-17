x = mouse_x;
y = mouse_y;

image_xscale = 2;
image_yscale = 2;

image_angle++;

if (mouse_check_button_pressed(mb_left) and pode_atirar) {
    var _tiro = instance_create_layer(mouse_x, mouse_y, "Instances", obj_tiro_revolver);
    _tiro.speed = 4;
    _tiro.image_xscale = 3;
    _tiro.image_yscale = 3;
    _tiro.direction = image_angle
		scr_screen_shake(10, 10);
	//audio_play_sound(snd_tiro,8,false,1,2.92);
    // _tiro.gravity = 0.2;
}

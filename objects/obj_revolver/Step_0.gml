x = mouse_x;
y = mouse_y;

image_xscale = 0.5;
image_yscale = 0.5;

image_angle += mouse_wheel_down();

if (mouse_check_button_pressed(mb_any)) {
    var _tiro = instance_create_layer(mouse_x, mouse_y, "Instances", obj_tiro_revolver);
    _tiro.speed = 4;
		scr_screen_shake(10, 10);
	//audio_play_sound(snd_tiro,8,false,1,2.92);
    // _tiro.gravity = 0.2;
}

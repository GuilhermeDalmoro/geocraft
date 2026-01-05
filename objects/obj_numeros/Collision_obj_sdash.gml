/// @description Insert description here
if other.tomardano == true{
	var _dir = point_direction(x, y, other.x, other.y);

	with (other){
		empurrar_dir = _dir;
		estado = scr_sdash_hit;
		alarm[2] = 10;
		alarm[3] = 180;
		tomardano = false;
		vida -= 1;
		scr_screen_shake(20,5);
		audio_play_sound(snd_sdanonumero,5,false,1,3.29);
	}
}
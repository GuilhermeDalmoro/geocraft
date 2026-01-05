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
		audio_play_sound(snd_gmd_dano,15,false,100,2.20);
		scr_screen_shake(10.8,5);
		gerar_texto_flutuante(obj_sdash.x, obj_sdash.y - 2, "DAHM!", c_white, 120, "Instances");
	
	}
}
/// @description Insert description here
if (global.pause == false){
	script_execute(estado);

	depth = -y;
	
	if vida <= 0{
		global.inimigos_mortos += 1;
		instance_destroy();
		audio_pause_sound(snd_minion_andrius_morte);
		audio_play_sound(snd_minion_andrius_morte,15,false,1,5.50);
		global.minions_mortos += 1;
		obj_boss_andrius.vida -= 10;
		scr_screen_shake(13,60);
		instance_create_layer(x,y,"Instances",obj_boss_andrius_ataque_2)
	}
}
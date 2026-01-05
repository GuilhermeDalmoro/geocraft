if (global.pause == false){
	if fim_da_animacao(){
		var _dir = 2;
		var _ang = irandom_range(-3,3)
		repeat(6){
			var _inst = instance_create_layer(x, y, "Instances",obj_boss_andrius_projetil);
			_inst.speed = 3;
			_inst.direction = _dir + _ang;
			_inst.image_xscale = 1;
			_dir += 45 + _ang;
		}
		instance_destroy();
		audio_pause_sound(snd_esplosao_fragmentada)
		audio_play_sound(snd_esplosao_fragmentada,2,0,24)
	}
}
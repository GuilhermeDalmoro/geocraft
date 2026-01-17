#macro AU_TIPO_SFX		   "SFX"
#macro AU_TIPO_MUSICA	   "MUSICA"

function audio_controle(_str_sfx, _str_musica, _str_mestre) constructor{
	global.audio_controller = self;
	lista_audio = ds_list_create();
	
	global_sfx = _str_sfx;
	global_musica = _str_musica;
	global_mestre = _str_mestre;
	
	///@method update()
	static update = function(){
		vol_sfx = variable_global_get(global_sfx) * variable_global_get(global_mestre);
		vol_musica = variable_global_get(global_musica) * variable_global_get(global_mestre);
		
		var _tamanho = ds_list_size(lista_audio);
		for(var _i = 0; _i < _tamanho; _i++){
			lista_audio[| _i].update();	
		}
	}
}


function audio_elemento() constructor {
		controle = global.audio_controller;
		
		ds_list_add(controle.lista_audio, self)
		
		play = false;
		som_id = noone;
		tipo = noone;
		offset = 1;

		///@method update
		static update = function(){		}

}


function tocar_audio_unico(_sound_id, _tipo, _offset = 1) : audio_elemento() constructor{
	som_id = _sound_id;
	tipo = _tipo;
	offset = _offset;
	
			///@method update
		static update = function(){
			if(play){
				var _snd = audio_play_sound(som_id, 0, false)
				
				var _level
				if(tipo == AU_TIPO_SFX){
					_level = controle.vol_sfx * offset	
				}else{
						_level = controle.vol_musica * offset	
				}
							
					audio_sound_gain(_snd, _level, 0)		
							play = false;
			}
		}
}


function tocar_audio_loop(_sound_id, _tipo, _mili_segundos, _offset = 1) : audio_elemento() constructor{
		som_id = _sound_id;
		tipo = _tipo;
		offset = _offset;
		id_tocando = noone
		vol = 0;
		vol_veloc = 1 / (game_get_speed(gamespeed_fps) * (_mili_segundos * 0.001));
		
		///@method update
		static update = function(){
			if(play){
				if(!audio_is_playing(id_tocando)){
						id_tocando = audio_play_sound(som_id, 1, true)
				}
				
				if (vol < 1){vol += vol_veloc}else{vol = 1}
			}
			if (!play){
					if (vol > 0){vol -= vol_veloc}else{vol = 0 audio_stop_sound(id_tocando)}
			}
			
			if(audio_is_playing(id_tocando)){
				var _level
				if(tipo == AU_TIPO_SFX){
					_level = controle.vol_sfx * vol * offset	
				}else{
						_level = controle.vol_musica * vol * offset	
				}
				audio_sound_gain(id_tocando, _level, 0)
			}
			
		}
	
}

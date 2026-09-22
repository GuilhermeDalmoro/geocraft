if(global.pause == false){
	script_execute(estado);
	image_xscale = 0.5;
	image_yscale = 0.5;
	//scr_movimento_senoidal(room_width / 2, room_height / 2, 35, 0.05);
    
    comecou_luta = true;
    
if vida <= 0{
	   global.inimigos_mortos += 1;
       gc_game_state_sync_from_legacy();
       gc_quest_notify("matar", "andrius", 1);
       gc_quest_notify("matar", "inimigo", 1);
       gc_state_flag_set("andrius_derrotado", true);
	   instance_destroy();
	   audio_pause_sound(snd_andrius_batalha);
	   var _sequence = sq_andrius_defeat;
	   var _layer_name = "sequences";
	   layer_sequence_create(_layer_name,0,0,_sequence);
	   instance_destroy(obj_minion_andrius_1);
	   instance_destroy(obj_numeros)
	   instance_destroy(obj_boss_andrius_ataque_2)
	   instance_destroy(obj_boss_andrius_projetil);
	   setar_camera();
   
	drop_moedas(x -10 ,y + 10,50,100);
   
	}
}

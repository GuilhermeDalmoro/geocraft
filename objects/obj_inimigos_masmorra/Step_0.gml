global.masmorra_data[| id_masmorra].x = x;
global.masmorra_data[| id_masmorra].y = y;



if global.pause == false{
     script_execute(estado);

	depth = -y;

	if vida <= 0{
		 sprite_index = spr_gmd_morte;
		 if image_index >= sprite_get_number(sprite_index) - 1{
			  instance_destroy(); // Destrói o inimigo após a animação
			  drop_moedas(x ,y , 10, 12)
			  audio_play_sound(snd_mortegmd,1,false,1,1.15);
			  global.inimigos_mortos += 1;
			  _inst = instance_create_layer(x+10,y-10,"Instances",obj_orb);
			 _inst = instance_create_layer(x-10,y+10,"Instances",obj_orb);
			 _inst.image_blend = choose(c_aqua, c_purple, c_yellow, c_red, c_orange, c_blue)
             //scr_missoes_notificar("matar", "inimigo_basico");

			 }
		}
}

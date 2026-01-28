if !active exit
if (montado) exit;

script_execute (estado);

depth = -y;

#region Ferramenta
if (keyboard_check_pressed(ord("C"))) {
	ferramenta_selecionada = !ferramenta_selecionada;
	if (ferramenta_selecionada) {
	    arma = noone;
	} else {
	    arma = ARMAS.Espada; 
	}
}

segura_ferramenta();

seletor();

#endregion

#region Estamina
if alarm[1] <= 0{
estamina += 1;
}
estamina = clamp(estamina, 0, max_estamina);
#endregion

#region Dialogo

if (!global.dialogo_acontecendo){
	if distance_to_object(obj_par_npc)<= 15 {
		if keyboard_check_pressed(ord("F")) or gamepad_button_check_pressed(global.controle,gp_face2){
				global.dialogo_acontecendo = true
		var _npc = 	instance_nearest(x,y,obj_par_npc);
		var _dialogo = instance_create_layer(x,y, "Dialogo", obj_dialogo);
		_dialogo.npc_nome = _npc.nome;
        _dialogo.npc_ref = _npc 
		}
	}
}

#endregion

#region Magia
if (keyboard_check_pressed(ord("Z"))) { // exemplo, tecla Z pra usar magia
    switch(global.magia_selecionada) {
		
        case 0: //fogo
    //if instance_exists(obj_sdash) {
    //    with(obj_sdash) {
    //        //active = false;
    //        //visible = false;
            
    //        var _layer = layer_create(-700, "ataque_especial");
    //        layer_sequence_create(_layer, x, y, sq_ataque_especial_sdash1);
    //    }
    //}
		break;
		
		//repeat(8){
		//		var _inst = instance_create_layer(x, y, "Instances", obj_bola_de_fogo);
		//		_inst.angulo_base = dir;
		//	}

			
        case 1: // agua
			create_particle_effect(x,y - 800,"rain", 200, c_white, 10, 360, 2, 1000)
        break;

        case 2: //raio
		   

        break;

        case 3: //planta
           // create_particle_effect(x,y,"spark", 200, c_white, 10, 360, 10, 100)
        break;

        case 4: //shooter
		//instance_create_layer(x,y,"Instances", obj)
        break;

    }
}


#endregion

#region Morte
if (vida <= 0) {    
    obj_sdash.hspeed = -2;
    obj_sdash.image_angle += 2;
    instance_destroy(obj_sdash);
    room_goto(Room_game_over);
	active = false
}

#endregion

#region trocar arma

//if keyboard_check_pressed(ord("R")){
//	arma += 1;
//}

//if keyboard_check_pressed(ord("Q")){
//	arma -=1;
//}

//if arma >= ARMAS.Altura{
//arma = 0;	
//}else if arma < 0{
//	arma = ARMAS.Altura - 1;
//}
#endregion

#region Empurrar bloco
// empurrando blocos
var push_list = ds_list_create();
var _tem_bloco_h = instance_place_list(x + hveloc, y, obj_bloco_movel, push_list, false);
var _tem_bloco_v = instance_place_list(x , y + vveloc, obj_bloco_movel, push_list, false);


if (_tem_bloco_h){
	if(ds_list_size(push_list) > 0){
		for(var i = 0;  i < ds_list_size(push_list); i++){
			var bloco = push_list[| i];
				with(bloco){
					if(!place_meeting(x+other.hveloc, y, obj_parede)){
						x+= other.hveloc;
				}
			}
		}
	}
}

if (_tem_bloco_v){
	if(ds_list_size(push_list) > 0){
		for(var i = 0;  i < ds_list_size(push_list); i++){
			var bloco = push_list[| i];
				with(bloco){
					if(!place_meeting(x, y +other.vveloc, obj_parede)){
						y+= other.vveloc;
				}
			}
		}
	}
}

ds_list_destroy(push_list);

#endregion

#region  //provisorio pra usar os itens

 //if global.item_player = global.itens[| ITENS.arco]{
	// arma = ARMAS.Arco;
 //} 
 
 //if global.item_player = global.itens[| ITENS.espadalv1]{
	// arma = ARMAS.Espada;
 //} 
 
 #endregion
 
#region Outros
 //XP 
// xp++;
 
 //if keyboard_check_pressed(vk_space){
	 //xp += 100;
 //}	
 
 //if xp >= max_xp[insignia]{
	//xp = xp - max_xp[insignia];
	//insignia += 1;
 //}
 
if keyboard_check_pressed(ord("O")){
    instance_create_layer(x ,y, "Instances", obj_lootbox)
 }

 #endregion

#region fade
// Fade de transição simples – roda todo frame se tiver ativo
if (fade_estado == 1) {  // Fechando
    fade_alpha += fade_vel;
    if (fade_alpha >= 1) {
        fade_alpha = 1;
        room_goto(target_sala);
        x = target_x;
        y = target_y;
        fade_estado = 2;  // agora abre na nova sala
    }
}

if (fade_estado == 2) {  // Abrindo
    fade_alpha -= fade_vel * 1.2;  // abre um pouco mais rápido
    if (fade_alpha <= 0) {
        fade_alpha = 0;
        fade_estado = 0;
    }
}

#endregion

#region cavalos

// montar
if (!montado) {
    var cav = instance_place(x, y, obj_cavalos);
       if (cav != noone && keyboard_check_pressed(ord("R"))) {
           montado = true;
           meu_cavalo = cav;
   
           cav.montado = true;
           cav.cavaleiro = id;
       }
}

// desmontar
if (montado && keyboard_check_pressed(ord("Q"))) {
    montado = false;

    visible = true;

    x = meu_cavalo.x + 16;
    y = meu_cavalo.y;

    meu_cavalo.montado = false;
    meu_cavalo.cavaleiro = noone;

    meu_cavalo = noone;
}


if keyboard_check_pressed(vk_right){
    room_goto(Room_dentro_masmorra);
}

#endregion

#region Jukebox

audio_listener_position(x, y, 0);


#endregion

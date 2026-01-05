// Script assets have changed for v2.3.0 see
function scr_sdash_colisao(){
	if place_meeting(x + hveloc, y, obj_parede){
 while !place_meeting(x + sign(hveloc), y, obj_parede){
 x += sign(hveloc);


 }
 hveloc = 0;
}

x += hveloc;

 
 if place_meeting(x, y + vveloc, obj_parede){
 while !place_meeting(x, y + sign (vveloc), obj_parede){
 y += sign (vveloc);
 }
 vveloc = 0;
 }
 
 y += vveloc;
}
	
function scr_sdash_correndo() {
    if (global.pause == true) exit;
		if(!pode_andar){
			
			hveloc = 0;
			vveloc = 0;
			
		}else{
			    gamepad_set_axis_deadzone(global.controle, 0.25);

			    // Movimentação
			    direita = keyboard_check(ord("D")) or gamepad_axis_value(global.controle, gp_axislh) > 0.25;
			    cima = keyboard_check(ord("W")) or gamepad_axis_value(global.controle, gp_axislv) < -0.25;
			    esquerda = keyboard_check(ord("A")) or gamepad_axis_value(global.controle, gp_axislh) < -0.25;
			    baixo = keyboard_check(ord("S")) or gamepad_axis_value(global.controle, gp_axislv) > 0.25;

			    hveloc = (direita - esquerda);
			    vveloc = (baixo - cima);

			    veloc_dir = point_direction(x, y, x + hveloc, y + vveloc);

			    if (hveloc != 0 or vveloc != 0) {
			        veloc = 2;
			    } else {
			        veloc = 0;
			    }

			    hveloc = lengthdir_x(veloc, veloc_dir);
			    vveloc = lengthdir_y(veloc, veloc_dir);

			    scr_sdash_colisao();

			    // Direção
			    if (gamepad_is_connected(global.controle)) {
			        if (gamepad_axis_value(global.controle, gp_axislh) != 0 or gamepad_axis_value(global.controle, gp_axislv)) {
			            dir = floor((point_direction(x, y, x + gamepad_axis_value(global.controle, gp_axislh), y + gamepad_axis_value(global.controle, gp_axislv)) + 45) / 90);
			        }
			    } else {
			        dir = floor((point_direction(x, y, mouse_x, mouse_y) + 45) / 90);
			    }

			    // Sprites
			    if (hveloc == 0 and vveloc == 0) {
			        switch (dir) {
			            default: sprite_index = spr_sdash_parado_direita; break;
			            case 1: sprite_index = spr_sdash_parado_cima; break;
			            case 2: sprite_index = spr_sdash_parado_esquerda; break;
			            case 3: sprite_index = spr_sdash_parado_baixo; break;
			        }
			    } else {
			        switch (dir) {
			            default: sprite_index = spr_sdash_correndo_direita; break;
			            case 1: sprite_index = spr_sdash_correndo_cima; break;
			            case 2: sprite_index = spr_sdash_correndo_esquerda; break;
			            case 3: sprite_index = spr_sdash_correndo_baixo; break;
			        }
			    }

			    // Dash
			    if (estamina >= 10) {
			        if (mouse_check_button_pressed(mb_right) or gamepad_button_check_pressed(global.controle, gp_shoulderr)) {
			            estamina -= 10;
			            alarm[1] = 120;
			            alarm[0] = 8;
			            if (gamepad_is_connected(global.controle)) {
			                if (gamepad_axis_value(global.controle, gp_axislh) != 0 or gamepad_axis_value(global.controle, gp_axislv)) {
			                    dash_dir = point_direction(x, y, x + gamepad_axis_value(global.controle, gp_axislh), y + gamepad_axis_value(global.controle, gp_axislv));
			                }
			            } else {
			                dash_dir = point_direction(x, y, mouse_x, mouse_y);
			            }
			            estado = scr_sdash_dash;
			        }
			    }

			// Ataque ou uso da ferramenta
			if (mouse_check_button_pressed(mb_left) or gamepad_button_check_pressed(global.controle, gp_face3)) {

			    // Primeiro: ferramenta (mineração)
			    if (ferramenta_selecionada) {
			        usa_ferramenta();
			        exit;
			    }

			    // Depois: verificar se há item equipado
			    if (global.item_player != noone) {

			        // Se o item for uma arma, usa o ataque da arma!
					if (global.item_player.tipo == TIPO_ITENS.armamento) {

					   global.item_player.usa_arma();

					    exit;
					}

			    }
			    // Caso não tenha arma → ataque normal (socão)
			    ds_list_clear(inimigos_atingidos)
			    image_index = 0;

			    switch (dir) {
			        default: sprite_index = spr_sdash_atacando_direita; mask_index = spr_sdash_atacando_direita_hb; break;
			        case 1: sprite_index = spr_sdash_atacando_cima; mask_index = spr_sdash_atacando_cima_hb; break;
			        case 2: sprite_index = spr_sdash_atacando_esquerda; mask_index = spr_sdash_atacando_esquerda_hb; break;
			        case 3: sprite_index = spr_sdash_atacando_baixo; mask_index = spr_sdash_atacando_baixo_hb; break;
			    }

			    estado = scr_sdash_atacando;
			}
		}
}

function scr_sdash_dash(){
	tomardano = false;
	
    hveloc = lengthdir_x(dash_veloc, dash_dir);
	vveloc = lengthdir_y(dash_veloc, dash_dir);
	
	scr_sdash_colisao();
	
	var _inst = instance_create_layer(x, y, "Instances", obj_dash);
	_inst.sprite_index = sprite_index;
}

function scr_sdash_atacando() {

    if (ferramenta_selecionada) {
        estado = scr_sdash_correndo;
        return; // sai da função corretamente
    }

    var _inimigos_na_hitbox = ds_list_create();
    var _inimigos = instance_place_list(x, y, obj_par_inimigos, _inimigos_na_hitbox, false);

    if (_inimigos > 0) {

        for (var _i = 0; _i < _inimigos; _i++) {

            var _inimigoID = _inimigos_na_hitbox[| _i];

            if (ds_list_find_index(inimigos_atingidos, _inimigoID) == -1) {

                ds_list_add(inimigos_atingidos, _inimigoID);

                with (_inimigoID) {

                    vida -= obj_sdash.dano;

                    var _dir = point_direction(obj_sdash.x, obj_sdash.y, x, y);
                    empurrar_dir = _dir;
                    empurrar_veloc = 6;

                    estado = scr_art_hit;
                    alarm[1] = 5;
                    hit = true;

                    var _inst = instance_create_layer(x, y, "Instances", obj_dano_highlight);
                    _inst.alvo = other;
                    _inst.dano = obj_sdash.dano;

                    scr_screen_shake(15,5);
                }
            }
        }
    }

    ds_list_destroy(_inimigos_na_hitbox);

    if (fim_da_animacao()) {
        mask_index = spr_sdash_correndo_baixo
        estado = scr_sdash_correndo;
        atacar = false;
    }
}

function scr_sdash_hit(){
		if alarm[2] > 0{
	//obj_som.sfx_sdash_dano.play = true
	//audio_play_sound(snd_mortegmd,3,false,1,1.50);
	hveloc = lengthdir_x(3, empurrar_dir);
	vveloc = lengthdir_y(3, empurrar_dir);
	
	scr_sdash_colisao();
		}else{
			estado = scr_sdash_correndo;
		}
	}

function scr_sdash_arco(){
	dir =floor((point_direction(x, y, mouse_x, mouse_y) + 45)/90);
	
	switch dir{
		//direita
		default:
		sprite_index = spr_sdash_arco_direita;
		break;
		//cima
		case 1:
		sprite_index = spr_sdash_arco_cima;
		break;
		//esquerda
		case 2:
		sprite_index = spr_sdash_arco_esquerda;
		break;
		//baixo
		case 3:
		sprite_index = spr_sdash_arco_baixo;
		break;
	}
	
		if fim_da_animacao(){
			image_index = 1;	
		}
	
	if mouse_check_button_released(mb_left){
		if image_index >= 2{
				var _dirf = point_direction(x, y, mouse_x, mouse_y);
				var _xxf = lengthdir_x(4, _dirf)
				var _yyf = lengthdir_y(4, _dirf)
				
			var _instf	= instance_create_layer(x +_xxf, y + _yyf, "Instances", obj_flecha);
			_instf.direction = _dirf;
			_instf.image_angle = _dirf;
			_instf.speed = 8;
			//_instf.gravity_direction = .1
			
			empurrar_dir = point_direction(mouse_x, mouse_y, x, y);
			alarm[2] = 5;
			estado = scr_sdash_hit;
			
			//estado = scr_sdash_correndo;	
			
		}else{
			estado = scr_sdash_correndo;	
		}
	}
	
}
	
function scr_sdash_cajado(){
	// Define a direção baseada no mouse
    dir = floor((point_direction(x, y, mouse_x, mouse_y) + 45) / 90);
    
    // Define o sprite correto
    switch dir {
        default: sprite_index = spr_sdash_cajado_direita; break;
        case 1: sprite_index = spr_sdash_cajado_cima; break;
        case 2: sprite_index = spr_sdash_cajado_esquerda; break;
        case 3: sprite_index = spr_sdash_cajado_baixo; break;
    }


    // Se o jogador soltar o clique, atira um projétil
    if (mouse_check_button(mb_left)) {
		
	        var _dir = point_direction(x, y, mouse_x, mouse_y);
	        var _xf = lengthdir_x(4, _dir);
	        var _yf = lengthdir_y(4, _dir);
        
	        var _proj = instance_create_layer(x + _xf, y + _yf, "Instances", obj_magia_lv1);
	        _proj.direction = _dir;
	        _proj.image_angle = _dir;
	        _proj.speed = 3;
			_proj.image_xscale = 0.5
			_proj.image_yscale = 0.5
        
	        alarm[2] = 5;
	        estado = scr_sdash_hit; // Volta pro estado de hit
			scr_screen_shake(10,10)
    }else{
		estado = scr_sdash_correndo;	
	}
}

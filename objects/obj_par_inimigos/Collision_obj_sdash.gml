/// @description Insert description here
if other.tomardano == true && mask_index = spr_sdash_parado_baixo{
	var _dir = point_direction(x, y, other.x, other.y);

	with (other){
		empurrar_dir = _dir;
		estado = scr_sdash_hit;
		alarm[2] = 10;
		alarm[3] = 180;
		tomardano = false;
		vida -= 1;
		  var _inst = instance_create_layer(x ,y, "Instances", obj_dano_highlight);
		_inst.alvo = other;
		_inst.dano = 1;
		scr_screen_shake(10.8,5);
	}
}


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
		instance_create_layer(x,y,"Instances", obj_minion_andrius_1);
		scr_screen_shake(14,6);
	}
}
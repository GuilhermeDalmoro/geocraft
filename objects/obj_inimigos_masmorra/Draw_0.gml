/// @description Insert description here
event_inherited();
if hit == true{
  gpu_set_fog(true, c_red, 0, 0);	
draw_self();
gpu_set_fog(false, c_red, 0, 0);
}else{
draw_self();
}

if dest_x < x{
	image_xscale = -1;
}else{
	image_xscale = 1;
}

/*
O gmd no futuro tera um ataque meio diferenciado
mude os efeitos de ataque dos personagens 
*/
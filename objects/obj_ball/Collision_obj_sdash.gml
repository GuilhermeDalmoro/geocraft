/// @description Insert description here
// You can write your code in this editor
/// @description Insert description here
if hit == true{
  gpu_set_fog(true, c_white, 0, 0);	
  draw_sprite(spr_art_sombra, 0, x+2, y + 3);
draw_self();
gpu_set_fog(false, c_white, 0, 0);
}else{
	 draw_sprite(spr_art_sombra, 0, x+2, y + 3);
draw_self();
}

if dest_x < x{
	image_xscale = -1;
}else{
	image_xscale = 1;
}
// Inherit the parent event
event_inherited();


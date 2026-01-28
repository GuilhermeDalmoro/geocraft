shader_set(sd_saturacao);
shader_set_uniform_f(shader_get_uniform(sd_saturacao, "u_saturation"), 2); // 1.8 = saturado

draw_sprite_ext(spr_sombra_item, 0, x - 14, y + 5, 1,1, 0, c_white, .5);

draw_self();

if alarm[3] > 0{
 if image_alpha >= 1{
	 dano_alfa = -0.05;
 }else if image_alpha <= 0{
	 dano_alfa = 0.05;
 }
 
 image_alpha += dano_alfa;
}else{
	image_alpha = 1;
}

shader_reset();
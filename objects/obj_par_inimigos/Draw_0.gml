/// @description Insert description here
if hit == true{
  gpu_set_fog(true, c_white, 0, 0);	
  //draw_sprite(spr_art_sombra, 0, x+2, y + 3);
draw_self();
gpu_set_fog(false, c_white, 0, 0);
}else{
	draw_self();
}

if dest_x < x{
	image_xscale = -1;
}else{
	image_xscale = 1;
}

//para desenhar a barrinha de vida do inimigo
if alarm[2] >= 0 {
	var _sprw = sprite_get_width(spr_hud_barra_inimigo)
	draw_sprite_ext(spr_hud_barra_inimigo,0,x - _sprw /2,y + 20, 1,1,0,c_white,1);
	draw_sprite_ext(spr_hud_barra_inimigo_vida,0,x - _sprw /2,y + 20, vida/max_vida,1,0,c_white,1);
	draw_set_font(fnt_minecraft)
	var _texto_x = x - string_width(nome_inimigo) / 2;
    var _texto_y = y - sprite_height / 2 - 10;
	draw_text(_texto_x, _texto_y, nome_inimigo)
	draw_set_font(-1);
}


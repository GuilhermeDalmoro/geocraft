if (global.pause || global.dialogo_acontecendo) exit;

if  instance_exists(obj_sdash) and obj_sdash.active{
var _escala =3 ;
var _guia = display_get_gui_height();
var _spra = sprite_get_height(spr_hud_vida) * _escala;
var _huda = _guia - _spra;

var _vida= obj_sdash.vida;
var _maxvida = obj_sdash.max_vida;
var _estamina = obj_sdash.estamina;
var _maxestamina = obj_sdash.max_estamina;


//BARRA DE VIDA DO BOSS
var _gl = display_get_gui_width();
if (instance_exists(obj_boss_andrius)){
    if obj_boss_andrius.comecou_luta{
    var _sprw = sprite_get_width(spr_boss_hud) * _escala;
   	draw_sprite_ext(spr_boss_hud,0,_gl/2 - _sprw/2,100,_escala,_escala,0,c_white,1);
   	draw_sprite_ext(spr_boss_vida,0,_gl/2 - _sprw/2 + 6,100,obj_boss_andrius.vida/obj_boss_andrius.max_vida * _escala,_escala,0,c_white,1);
    }
}

//BARRA DA VIDA 
draw_sprite_ext(spr_hud_barra_vida, 0, 0, _huda, (_vida/_maxvida) * _escala, _escala, 0, c_white, 1);

//BARRA DA ESTAMINA
draw_sprite_ext(spr_hud_barra_estamina, 0, 0, _huda + 24,(_estamina/_maxestamina) * _escala, _escala, 0, c_white, 1)

//HUD
draw_sprite_ext(spr_hud_vida, 0, 0, _huda, _escala, _escala, 0, c_white, 1);

//MOEDAS
draw_sprite_ext(spr_moeda, 0, 20, _huda + 58, .9, .9, 0, c_white, 1);
draw_set_font(fnt_botao);
draw_text(36, _huda + 52, global.moedas);
draw_set_font(-1);

}else{
	exit;
}












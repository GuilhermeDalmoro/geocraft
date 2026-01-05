visible = global.seletor_visivel;

if(visible){
	alvo = instance_place(x, y, obj_mineravel)
}else{
	alvo = noone
}



if (alvo){
	image_blend = c_red;
}else{
	image_blend = c_white;
}
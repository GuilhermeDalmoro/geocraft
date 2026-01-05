if (instance_exists(obj_almudeao)){
	x = lerp(x, obj_almudeao.x, 0.05); 

	y = lerp(y, obj_almudeao.y, 0.05);
	
	scr_movimento_senoidal(obj_almudeao.x + 24,obj_almudeao.y,8,0.02);
}else{
	instance_destroy();	
}
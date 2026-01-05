if distance_to_object(obj_sdash) < 25{
	if keyboard_check_pressed(vk_enter){
		if !instance_exists(obj_transicao_circulo){
			instance_create_layer(20,20, "Instances", obj_transicao_circulo)	
			obj_transicao_circulo.sala = Room_quarto_sdash
		}else{
			instance_destroy();
		}
	}
}
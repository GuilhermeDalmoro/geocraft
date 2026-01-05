terminou = false;
sendo_usada = false;

golpe = function() {
	if instance_exists(obj_sdash){
		if obj_sdash.active{
		    if (image_xscale >= 1) { // Direita
		        if (image_angle > -130 && !terminou) {
		            sendo_usada = true;
					//obj_som.sfx_golpe_picareta_madeira.play = true;
		            image_angle = lerp(image_angle, -180, 0.1);
		        } else {
		            terminou = true;
		        }
		        if (terminou) {
		            if (image_angle < 0) {
		                image_angle = lerp(image_angle, 0, 0.2);
		            } else {
		                image_angle = 0;
		                terminou = false;
		                sendo_usada = false;
		            }
		        }
		    } else { // Esquerda
		        if (image_angle < 130 && !terminou) {
		            sendo_usada = true;
				//	obj_som.sfx_golpe_picareta_madeira.play = true;
		            image_angle = lerp(image_angle, 180, 0.1);
		        } else {
		            terminou = true;
		        }
		        if (terminou) {
		            if (image_angle > 0) {
		                image_angle = lerp(image_angle, 0, 0.2);
		            } else {
		                image_angle = 0;
		                terminou = false;
		                sendo_usada = false;
		            }
		        }
		    }
		    return sendo_usada;
		}
	}else{
		instance_destroy();
	}
}
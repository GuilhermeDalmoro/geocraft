depth = -y

if instance_exists(obj_sdash){
	if (obj_sdash.y < y -20){
        if point_in_rectangle(obj_sdash.x, obj_sdash.y, bbox_left -10, bbox_top - 25, bbox_right + 10, bbox_top){
        	image_alpha = lerp(image_alpha, .5, .2) //faz a trasparencia ficar mais devagar
       	}else{
    		image_alpha = lerp(image_alpha,1, .1);
      	}  
    }
	
}
image_alpha -= 0.1;
if image_alpha <= 0 {
	obj_som.sfx_dash.play = true
    
   instance_destroy();
}
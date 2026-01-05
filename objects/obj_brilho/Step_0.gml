image_xscale = lerp(image_xscale, 0, 0.05);
image_yscale = image_xscale;

if (image_xscale <= 0.1){
	instance_destroy();	
}
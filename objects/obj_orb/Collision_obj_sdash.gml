if (obj_sdash.vida >= obj_sdash.max_vida){
	obj_sdash.vida += 0;	
}else{
	obj_sdash.vida += 2;	
}
global.orbs += 1; // Aumenta a contagem de orbs
image_alpha--;
y--;
instance_destroy(); // Destroi a orb coletada
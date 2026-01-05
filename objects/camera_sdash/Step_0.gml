//if !obj_sdash.active exit

//para seguir o sdash
if instance_exists(obj_sdash){
x = lerp(x, obj_sdash.x, 0.05); 

y = lerp(y, obj_sdash.y, 0.05);

}else{
global.pause = true;
}

if (shake_forca != 0){
x += random_range(-shake_forca, shake_forca);
y += random_range(-shake_forca, shake_forca);
}
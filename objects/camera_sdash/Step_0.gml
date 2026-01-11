//if !obj_sdash.active exit

//para seguir o sdash
if instance_exists(obj_sdash){
x = lerp(x, obj_sdash.x, vel_lerp_cam); 

y = lerp(y, obj_sdash.y, vel_lerp_cam);

}else{
global.pause = true;
}

//screen shake
if (shake_forca != 0){
x += random_range(-shake_forca, shake_forca);
y += random_range(-shake_forca, shake_forca);
}

//zoom 
cam_w_atual = lerp(cam_w_atual, cam_w_alvo, vel_lerp_cam)
cam_h_atual = lerp(cam_h_atual, cam_h_alvo, vel_lerp_cam)

camera_set_view_size(cam, cam_w_atual, cam_h_atual)

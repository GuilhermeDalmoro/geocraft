// Script assets have changed for v2.3.0 see
function scr_art_colisao(){
	if place_meeting(x + hveloc, y, obj_parede){
 while !place_meeting(x + sign(hveloc), y, obj_parede){
 x += sign(hveloc);


 }
 hveloc = 0;
}

x += hveloc;

 
 if place_meeting(x, y + vveloc, obj_parede){
 while !place_meeting(x, y + sign (vveloc), obj_parede){
 y += sign (vveloc);
 }
 vveloc = 0;
 }
 
 y += vveloc;
}

function scr_art_checar_sdash(){
	if distance_to_object(obj_sdash) <= dist_aggro{
		estado = scr_art_perseguindo;
		}
}

function scr_art_escolher_estado(){
	scr_art_checar_sdash();

    prox_estado = choose(scr_art_andando, scr_art_parado);
	
	if prox_estado == scr_art_andando{
	estado = scr_art_andando;
	dest_x = irandom_range(0, room_width);
	dest_y = irandom_range(0, room_height);
	}else if prox_estado == scr_art_parado{
		estado = scr_art_parado;
	}
}

function scr_art_andando(){
	scr_art_checar_sdash();
    image_speed = 1;
	
	if distance_to_point(dest_x, dest_y) > veloc{
	var _dir = point_direction(x, y, dest_x, dest_y);
	hveloc = lengthdir_x(veloc, _dir);
	vveloc = lengthdir_y(veloc, _dir);
	
	scr_art_colisao();
	}else{
		x = dest_x;
		y = dest_y;
	}
}

function scr_art_parado(){
	scr_art_checar_sdash();
    image_speed = 0.5;
}

function scr_art_perseguindo(){
	//image_speed = 1.5;
	sprite_index = sprite_perseg
	
	dest_x = obj_sdash.x;
	dest_y = obj_sdash.y;
	
	var _dir = point_direction(x, y, dest_x, dest_y);
	hveloc = lengthdir_x(veloc_perseg, _dir);
	vveloc = lengthdir_y(veloc_perseg, _dir);
	
	scr_art_colisao();
	
	if distance_to_object(obj_sdash) >= dist_desaggro{
		estado = scr_art_escolher_estado;
		alarm[0] = irandom_range(120, 240);
	}
}
	
function scr_art_hit(){
		alarm[2] = 180
		empurrar_veloc = lerp(empurrar_veloc, 0, 0.05);
		
		hveloc = lengthdir_x(empurrar_veloc, empurrar_dir);
		vveloc = lengthdir_y(empurrar_veloc, empurrar_dir);
		
		scr_art_colisao();
	}
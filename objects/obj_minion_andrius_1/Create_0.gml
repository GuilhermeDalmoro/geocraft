/// @description Insert description here
event_inherited();
randomize();

//movimentação
estado = scr_art_escolher_estado;
prox_estado = 0;

hveloc = 0;
vveloc= 0;
veloc = 1;
veloc_perseg = 1;

dest_x = 0;
dest_y = 0;

alarm[0] = 1;

dist_aggro = 100;
dist_desaggro = 50;

//combate
vida = 2;
empurrar_dir = 0;
empurrar_veloc = 0;
hit = false;

sprite_perseg = spr_minion_andrius_putin;
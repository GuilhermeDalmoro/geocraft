/// @description Insert description here
event_inherited();
randomize();

nome_inimigo = "Art"

//movimentação
estado = scr_art_escolher_estado;
prox_estado = 0;

hveloc = 0;
vveloc= 0;
veloc = 0.2;
veloc_perseg = 0.6;

dest_x = 0;
dest_y = 0;

alarm[0] = 1;

dist_aggro = 50;
dist_desaggro = 100;

//combate
vida = 2;
empurrar_dir = 0;
empurrar_veloc = 0;
hit = false;

//sprites
sprite_perseg = spr_art_persegue
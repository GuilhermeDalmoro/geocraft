/// @description Insert description here
randomize();

nome_inimigo = ""

//movimentação
estado = scr_art_escolher_estado;
prox_estado = 0;

hveloc = 0;
vveloc= 0;
veloc = 0.2;
veloc_perseg = 0.5;

dest_x = 0;
dest_y = 0;

alarm[0] = 1;

dist_aggro = 50;
dist_desaggro = 100;

//combate
max_vida = 5;
vida = max_vida;
empurrar_dir = 0;
empurrar_veloc = 0;
hit = false;

queimando    = false;
queima_timer = 0;
queima_accum = 0;
queima_dps   = 0;
queima_tick  = 10;


stun_timer = 0;



//sprites
sprite_perseg = -1;

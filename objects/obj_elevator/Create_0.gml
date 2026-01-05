/// @description Insert description here
event_inherited();
randomize();
nome_inimigo =  "Elevator"

//movimentação
estado = scr_art_escolher_estado; //escolhe qual estado o gmd vai entrar
prox_estado = 0; //proximo estado

hveloc = 0; //velocidade horizontal
vveloc= 0; //velocidade vertical
veloc = 0.5; //velocidade
veloc_perseg = 0.5; //velocidade de perseguição

dest_x = 0;
dest_y = 0;

morrendo = false;

alarm[0] = 1;

dist_aggro = 95;
dist_desaggro = 150;

//combate
max_vida = 9;
vida = max_vida;
empurrar_dir = 0;
empurrar_veloc = 0;
hit = false;

//sprites
sprite_perseg = spr_elevator;

queimando    = false;
queima_timer = 0;
queima_accum = 0;
queima_dps   = 0;
queima_tick  = 10;


stun_timer = 0;

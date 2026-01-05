/// @description Insert description here
event_inherited();
randomize();
nome_inimigo =  "Lol"

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

image_xscale = 0.5
image_yscale = 0.5

dist_aggro = 35;
dist_desaggro = 50;

//combate
max_vida = 2;
vida = max_vida;
empurrar_dir = 0;
empurrar_veloc = 0;
hit = false;

//sprites
sprite_perseg = spr_espinho;

queimando    = false;
queima_timer = 0;
queima_accum = 0;
queima_dps   = 0;
queima_tick  = 10;


stun_timer = 0;

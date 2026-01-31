var info = {
    _x : x,
    _y : y,
    tipo : object_index,
    vivo : true
};

ds_list_add(global.masmorra_data, info);
id_masmorra = ds_list_size(global.masmorra_data) - 1;


randomize();
nome_inimigo =  "CU"

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

dist_aggro = 35;
dist_desaggro = 50;

//combate
max_vida = 6;
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
sprite_perseg = spr_big_dog
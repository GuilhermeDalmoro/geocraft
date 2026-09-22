montado = false;
cavaleiro = noone;

vel = 2;

hveloc = 0;
vveloc = 0;

sprite_idle = spr_cavalo_parado;
sprite_run  = spr_cavalo_correndo;

image_speed = 1;
image_xscale = 1;



// Estado necessario para a missao de alimentar cavalos.
feed_key = "cavalo_" + room_get_name(room) + "_" + string(round(x)) + "_" + string(round(y));
alimentado = gc_state_flag_get(feed_key, false);
feed_flash = 0;

/// @description Insert description here
script_execute(estado);

depth = -y;

image_blend++;


if (instance_exists(obj_sdash)) {
    
    var alvo = instance_nearest(x, y, obj_sdash);

    var dir = point_direction(x, y, alvo.x, alvo.y);

    dir += irandom_range(-30, 30); // bagunça a direção um pouco

    // Define a velocidade
    var vel = 2; // tu pode ajustar
    x += lengthdir_x(vel, dir);
    y += lengthdir_y(vel, dir);
}



if vida <= 0{
	instance_destroy();
	global.inimigos_mortos += 1;
}

if (queimando) {
    if (queima_timer > 0) {
        queima_timer--;
        queima_accum++;

        if (queima_accum >= queima_tick) {
            queima_accum = 0;
            if (variable_instance_exists(id, "vida")) {
                vida -= queima_dps;
            }
            // opcional: partículas de fogo, tremidinha, etc.
			//create_particle_effect(x,y,"spark",60,c_red,10,90,3,15)
        }
    } else {
        queimando = false;
    }
}


if (stun_timer > 0) {
    stun_timer--;
    // aqui você pode reduzir velocidade ou pular movimentação
    // ex: velocidade = 0; ou return; (se for script)
}

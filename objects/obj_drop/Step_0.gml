if (z >= 0) { // to no chao
    velz = 0;
    z = 0;
} else { // n to no chao
    velz += grav;
}

z += velz;

speed = lerp(speed, 0, .1)

image_xscale = sin(current_time * osc_freq + osc_offset) * osc_amp;

if place_meeting(x, y, obj_sdash) && !destruir && posso_destruir {
    if (adiciona_ao_inventario(meu_id, qtd)) {
        destruir = true;
        instance_create_depth(x, y, depth -10, obj_brilho);
    }
}

if (destruir) {
    me_destruir();    
}

if (!destruir && !juntou) { // Só tenta juntar se não está destruindo nem juntou
    junta_item();
}
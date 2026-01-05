if (global.pause) {
    // Congela a animação no último quadro
    image_index = image_number - 1;
    image_speed = 0;
} else {
    // Continua a animação normalmente
    image_speed = 1;
}


if (place_meeting(x, y, obj_sdash) && !dialogo_ativo && !global.dialogo_acontecendo) {
    var _dialogo = instance_create_layer(x, y, "Dialogo", obj_dialogo);
    _dialogo.npc_nome = "Salva jogo";
    dialogo_ativo = true;
    global.dialogo_acontecendo = true;
    global.pause = true;
	//instance_destroy();
}
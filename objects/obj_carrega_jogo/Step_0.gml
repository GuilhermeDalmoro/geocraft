if (global.pause) {
    // Congela a animação no último quadro
    image_index = image_number - 1;
    image_speed = 0;
} else {
    // Continua a animação normalmente
    image_speed = 1;
}


if (place_meeting(x, y, obj_sdash)) {
    global.carrega_jogo();
}

image_blend = c_red
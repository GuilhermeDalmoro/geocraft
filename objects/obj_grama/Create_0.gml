sprite_index = choose(spr_gramav1, spr_gramav2,spr_gramav5, spr_gramav6);

image_speed = 0.2;

image_angle = 0;

//angulo do alvo no vento
target_angle = 0;

//contador pra mudar o angulo
timer_vento = 0;

//duração do vento
timer_vento_max = 3 * room_speed;

// 0 : parado, 1: direita, 2: esquerda
vento_fase = 0; 
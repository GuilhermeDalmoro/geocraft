depth = -y;
var _dist_sdash = distance_to_object(obj_sdash);
var _timer_max = (20 >= _dist_sdash) ? 1.5 * room_speed : 3 * room_speed; // 1.5s se perto, 3s se longe
image_speed = (20 >= _dist_sdash) ? 0.1 : 0.2; // Diminui image_speed se perto

// Contador do vento
timer_vento += 1;
if (timer_vento >= _timer_max) {
    timer_vento = 0;
    vento_fase = (vento_fase + 1) mod 3; // Ciclo: 0 (parado), 1 (direita), 2 (esquerda)
    switch (vento_fase) {
        case 0: target_angle = 0; break; // Parado
        case 1: target_angle = 10; break; // Direita
        case 2: target_angle = -10; break; // Esquerda
    }
}

image_angle = lerp(image_angle, target_angle, 0.1); // 0.1 = suavidade (menor = mais suave)

// Otimização: Para animação fora da tela
if (x < view_xview - 32 || x > view_xview + view_wview + 32 || y < view_yview - 32 || y > view_yview + view_hview + 32) {
    image_speed = 0;
} else {
    image_speed = (20 >= _dist_sdash) ? 0.1 : 0.2;
}
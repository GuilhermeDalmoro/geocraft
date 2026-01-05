// Primeiro, a magia segue normalmente a direção inicial
var alvo = instance_nearest(x, y, obj_par_inimigos); // Pega o inimigo mais próximo

if (alvo != noone && point_distance(x, y, alvo.x, alvo.y) < 50) { 
    // Se um inimigo estiver no raio de 50 pixels, suaviza a direção com lerp
    var angulo_alvo = point_direction(x, y, alvo.x, alvo.y);
    direction = lerp(direction, angulo_alvo, 0.025); // Quanto menor, mais suave (teste entre 0.05 e 0.2)
}

// Movimento normal da magia
x += lengthdir_x(speed, direction);
y += lengthdir_y(speed, direction);

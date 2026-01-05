function scr_movimento_senoidal(centro_x, centro_y, raio, velocidade) {
    // Aumenta o ângulo de rotação com o tempo para manter o movimento
    if (!variable_instance_exists(id, "angulo")) angulo = 0; // Inicializa o ângulo se não existir
    angulo += velocidade;

    // Define as coordenadas do movimento circular
    x = centro_x + raio * cos(angulo);
    y = centro_y + raio * sin(angulo);
}

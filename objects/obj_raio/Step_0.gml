// checar se o alvo ainda existe
if (!instance_exists(alvo)) {
    instance_destroy();
}

// dar dano no alvo
if (life == 5) { // só no primeiro frame
    if (variable_instance_exists(alvo, "vida")) {
        alvo.vida -= dano;
    }
    // opcional: aplicar stun
    alvo.stun_timer = 30; // meio segundo parado
}

// diminuir tempo de vida
life--;
if (life <= 0) instance_destroy();

//room_goto(other.sala);
//x = other.sdashx;
//y = other.sdashy;

// Collision com obj_transicao – fade simples e direto
if (fade_estado == 0) {
    fade_estado = 1;                  // começa fechando
    fade_alpha = 0;
    target_sala = other.sala;
    target_x = other.sdashx;
    target_y = other.sdashy;
}


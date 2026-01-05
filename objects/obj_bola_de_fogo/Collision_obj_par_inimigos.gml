// "other" é o inimigo atingido
// aplica dano instantâneo
if (variable_instance_exists(other, "vida")) {
    other.vida -= dano_impacto;
}

scr_screen_shake(3, 60)

// aplica queimadura (DOT)
// estas variáveis vão nascer no inimigo, se não existirem
other.queimando      = true;
other.queima_timer   = max(is_undefined(other.queima_timer) ? 0 : other.queima_timer, queima_dur);
other.queima_dps     = queima_dps;
other.queima_tick    = queima_tick;
other.queima_accum   = 0;  // acumulador pra contar ticks

// opcional: efeito de impacto aqui (faíscas, etc.)
create_particle_effect(other.x, other.y, "spark", 60, c_red, 40, 90, 2, 15)

// projétil se desfaz ao acertar
instance_destroy();

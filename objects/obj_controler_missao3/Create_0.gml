if (gc_state_flag_get("andrius_derrotado", false)) {
    instance_destroy();
    exit;
}

// Entrar na arena agora registra a luta como uma missao real.
gc_quest_start("andrius");

cutscene_tocada = false;
seq_inst = noone;

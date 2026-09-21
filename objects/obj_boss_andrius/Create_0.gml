event_inherited();

if (gc_state_flag_get("andrius_derrotado", false)) {
    instance_destroy();
    exit;
}

nome_inimigo = "Andrius";

max_vida = 60;
vida = max_vida;

empurrar_dir = 0;
empurrar_veloc = 0;
hit = false;

comecou_luta = false;
estado = scr_boss_escolher_ataque;

fase_boss = 1;
vida_anterior = vida;
hit_flash = 0;
aviso_luta = false;

// Variaveis herdadas existem, mas garantimos valores validos para magia.
queimando = false;
queima_timer = 0;
queima_accum = 0;
queima_dps = 0;
queima_tick = 12;
stun_timer = 0;

gc_quest_start("andrius");

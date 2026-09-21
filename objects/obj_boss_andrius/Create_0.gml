event_inherited();

if (gc_state_flag_get("andrius_derrotado", false)) {
    instance_destroy();
    exit;
}

nome_inimigo = "Andrius"

max_vida = 100;
vida = max_vida;
empurrar_dir = 0;
empurrar_veloc = 0;
hit = false

comecou_luta = false
// Variáveis do andrius
estado = scr_boss_escolher_ataque;  // Estado inicial do boss
//vida = 100; // Vida do boss
//max_vida = vida;

//// Create Event
//estado = "INTRO";
//estado_timer = 0;
//vida = 100;
//max_vida = vida;
//image_xscale = 0.5;
//image_yscale = 0.5;

gc_quest_start("andrius");

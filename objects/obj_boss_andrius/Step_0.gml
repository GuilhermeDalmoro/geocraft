if (global.pause) exit;

comecou_luta = true;

image_xscale = 0.5;
image_yscale = 0.5;

if (!aviso_luta) {
    aviso_luta = true;
    gc_quest_toast("ANDRIUS: ataque com clique, use Z para magia e desvie com dash", 240);
}

// Stun da magia de agua.
if (stun_timer > 0) {
    stun_timer--;
}
else {
    script_execute(estado);
}

// Queimadura agora funciona em boss tambem.
if (queimando) {
    if (queima_timer > 0) {
        queima_timer--;
        queima_accum++;

        if (queima_accum >= max(1, queima_tick)) {
            queima_accum = 0;
            vida -= max(0, queima_dps);
        }
    }
    else {
        queimando = false;
    }
}

// Feedback quando perde vida.
if (vida < vida_anterior) {
    hit_flash = 7;
    scr_screen_shake(5, 5);
}

vida_anterior = vida;

if (hit_flash > 0) {
    hit_flash--;
    image_blend = c_white;
    image_alpha = 0.65 + 0.35 * (hit_flash mod 2);
}
else {
    image_blend = c_white;
    image_alpha = 1;
}

// Fases simples e legiveis.
var _ratio = vida / max_vida;

if (_ratio <= 0.35 && fase_boss < 3) {
    fase_boss = 3;
    gc_quest_toast("ANDRIUS - FASE 3: ele ficou desesperado!", 160);
}
else if (_ratio <= 0.70 && fase_boss < 2) {
    fase_boss = 2;
    gc_quest_toast("ANDRIUS - FASE 2: ataques mais rapidos!", 160);
}

if (vida <= 0) {
    var _drop_x = x - 10;
    var _drop_y = y + 10;

    global.inimigos_mortos += 1;
    gc_game_state_sync_from_legacy();

    gc_quest_notify("matar", "andrius", 1);
    gc_quest_notify("matar", "inimigo", 1);
    gc_state_flag_set("andrius_derrotado", true);

    audio_pause_sound(snd_andrius_batalha);

    with (obj_minion_andrius_1) instance_destroy();
    with (obj_numeros) instance_destroy();
    with (obj_boss_andrius_ataque_2) instance_destroy();
    with (obj_boss_andrius_projetil) instance_destroy();

    drop_moedas(_drop_x, _drop_y, 50, 100);

    var _layer = layer_get_id("sequences");
    if (_layer != -1) {
        layer_sequence_create(_layer, 0, 0, sq_andrius_defeat);
    }

    setar_camera();
    gc_quest_toast("ANDRIUS DERROTADO!", 220);

    instance_destroy();
    exit;
}

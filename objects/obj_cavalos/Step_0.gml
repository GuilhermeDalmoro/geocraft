// Alimentacao: o dialogo ja ensina Control, agora a mecanica existe de verdade.
if (feed_flash > 0) {
    feed_flash--;
    image_blend = c_lime;
} else {
    image_blend = c_white;
}

if (!montado && !alimentado && instance_exists(obj_sdash)) {
    var _dist_feed = point_distance(x, y, obj_sdash.x, obj_sdash.y);

    if (_dist_feed <= 28 && keyboard_check_pressed(vk_control)) {
        alimentado = true;
        feed_flash = 45;

        global.cabalos_alimentados += 1;
        gc_game_state_sync_from_legacy();
        gc_quest_notify("alimentar", "cavalo", 1);

        tocar_som_efeito(snd_blip_2, 1, 1);
    }
}

#region movimentacao do cavalo
if (!montado) {
    sprite_index = sprite_idle;
    image_speed = 1;
}
else {

    var h = keyboard_check(ord("D")) - keyboard_check(ord("A"));
    var v = keyboard_check(ord("S")) - keyboard_check(ord("W"));

    hveloc = h * vel;
    vveloc = v * vel;

    if (h > 0) image_xscale = -1;
    if (h < 0) image_xscale = 1;

    if (h != 0 || v != 0) {
        sprite_index = sprite_run;
        image_speed = 1;
    }
    else {
        sprite_index = sprite_idle;
        image_speed = 1;
    }

    // Colisao horizontal corrigida: parede e arvore sao testadas separadamente.
    if (place_meeting(x + hveloc, y, obj_parede) || place_meeting(x + hveloc, y, obj_arvore)) {
        while (hveloc != 0
        && !place_meeting(x + sign(hveloc), y, obj_parede)
        && !place_meeting(x + sign(hveloc), y, obj_arvore)) {
            x += sign(hveloc);
        }
        hveloc = 0;
    }
    x += hveloc;

    // Colisao vertical corrigida tambem contra arvores.
    if (place_meeting(x, y + vveloc, obj_parede) || place_meeting(x, y + vveloc, obj_arvore)) {
        while (vveloc != 0
        && !place_meeting(x, y + sign(vveloc), obj_parede)
        && !place_meeting(x, y + sign(vveloc), obj_arvore)) {
            y += sign(vveloc);
        }
        vveloc = 0;
    }
    y += vveloc;

    if (instance_exists(cavaleiro)) {
        cavaleiro.x = x;
        cavaleiro.y = y - 10;

        if (h > 0) cavaleiro.sprite_index = spr_sdash_parado_direita;
        if (h < 0) cavaleiro.sprite_index = spr_sdash_parado_esquerda;
    }
}
#endregion

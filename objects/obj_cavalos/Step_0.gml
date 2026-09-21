// Sincroniza estado depois de load.
if (!alimentado && gc_state_flag_get(feed_key, false)) {
    alimentado = true;
}

if (mount_cooldown > 0) mount_cooldown--;

if (feed_flash > 0) {
    feed_flash--;
    image_blend = c_lime;
}
else {
    image_blend = c_white;
}

var _player = instance_exists(obj_sdash) ? instance_find(obj_sdash, 0) : noone;

if (global.pause) {
    hveloc = 0;
    vveloc = 0;
    exit;
}

// Interacoes usam distancia, nao colisao exata.
if (!montado && instance_exists(_player)) {
    var _dist = point_distance(x, y, _player.x, _player.y);

    if (!alimentado
    && _dist <= 44
    && keyboard_check_pressed(vk_control)) {

        alimentado = true;
        feed_flash = 45;

        gc_state_flag_set(feed_key, true);

        global.cabalos_alimentados += 1;
        gc_game_state_sync_from_legacy();
        gc_quest_notify("alimentar", "cavalo", 1);

        tocar_som_efeito(snd_blip_2, 1, 1);
        gc_quest_toast("Cavalo alimentado. Agora voce pode montar com R.", 100);
    }

    if (alimentado
    && mount_cooldown <= 0
    && _dist <= 44
    && keyboard_check_pressed(ord("R"))
    && !_player.montado) {

        montado = true;
        cavaleiro = _player;

        _player.montado = true;
        _player.meu_cavalo = id;
        _player.x = x;
        _player.y = y - 10;

        gc_quest_notify("montar", "cavalo", 1);
        gc_quest_toast("Montado! WASD move, R desmonta.", 100);
    }
}

#region movimentacao_do_cavalo
if (!montado) {
    sprite_index = sprite_idle;
    image_speed = 1;
}
else {
    var _h = keyboard_check(ord("D")) - keyboard_check(ord("A"));
    var _v = keyboard_check(ord("S")) - keyboard_check(ord("W"));

    hveloc = _h * vel;
    vveloc = _v * vel;

    if (_h > 0) image_xscale = -1;
    if (_h < 0) image_xscale = 1;

    if (_h != 0 || _v != 0) {
        sprite_index = sprite_run;
        image_speed = 1;
    }
    else {
        sprite_index = sprite_idle;
        image_speed = 1;
    }

    if (place_meeting(x + hveloc, y, obj_parede)
    || place_meeting(x + hveloc, y, obj_arvore)) {

        while (hveloc != 0
        && !place_meeting(x + sign(hveloc), y, obj_parede)
        && !place_meeting(x + sign(hveloc), y, obj_arvore)) {
            x += sign(hveloc);
        }

        hveloc = 0;
    }

    x += hveloc;

    if (place_meeting(x, y + vveloc, obj_parede)
    || place_meeting(x, y + vveloc, obj_arvore)) {

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

        if (_h > 0) cavaleiro.sprite_index = spr_sdash_parado_direita;
        if (_h < 0) cavaleiro.sprite_index = spr_sdash_parado_esquerda;
    }
    else {
        montado = false;
        cavaleiro = noone;
        mount_cooldown = 10;
    }
}
#endregion

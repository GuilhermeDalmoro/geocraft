/// @description Sistema central de magias do Sdash.

function gc_magic_name(_slot) {
    switch (_slot) {
        case 0: return "Fogo";
        case 1: return "Agua";
        case 2: return "Trovao";
        case 3: return "Planta";
        case 4: return "Shooter";
    }

    return "Desconhecida";
}

function gc_magic_is_unlocked(_slot) {
    if (!variable_global_exists("tem_magia") || !is_array(global.tem_magia)) return false;
    if (_slot < 0 || _slot >= array_length(global.tem_magia)) return false;
    return global.tem_magia[_slot];
}

function gc_magic_cost(_slot) {
    switch (_slot) {
        case 0: return 18;
        case 1: return 25;
        case 2: return 30;
        case 3: return 30;
        case 4: return 20;
    }

    return 999;
}

function gc_magic_cooldown(_slot) {
    switch (_slot) {
        case 0: return 24;
        case 1: return 70;
        case 2: return 80;
        case 3: return 120;
        case 4: return 18;
    }

    return 30;
}

function gc_magic_cast(_player, _slot) {
    if (!instance_exists(_player)) return false;
    if (_slot == noone) return false;

    _slot = floor(_slot);

    if (!gc_magic_is_unlocked(_slot)) {
        gc_quest_toast("Magia bloqueada: " + gc_magic_name(_slot), 90);
        return false;
    }

    if (variable_instance_exists(_player, "magia_cooldown")
    && _player.magia_cooldown > 0) {
        return false;
    }

    var _cost = gc_magic_cost(_slot);

    if (_player.estamina < _cost) {
        gc_quest_toast("Estamina insuficiente", 75);
        return false;
    }

    var _casted = false;

    switch (_slot) {
        case 0:
            // Fogo: tres espirais curtas mirando no cursor.
            var _base_angle = point_direction(_player.x, _player.y, mouse_x, mouse_y);
            var _offsets = [-12, 0, 12];

            for (var _i = 0; _i < array_length(_offsets); _i++) {
                var _fire = instance_create_layer(
                    _player.x,
                    _player.y,
                    "Instances",
                    obj_bola_de_fogo
                );

                _fire.angulo_base = _base_angle + _offsets[_i];
                _fire.dano_impacto = max(1, _player.dano);
                _fire.queima_dps = 1;
                _fire.queima_tick = 12;
                _fire.queima_dur = 90;
            }

            tocar_som_efeito(snd_blip_2, 1, 1.08);
            _casted = true;
        break;

        case 1:
            // Agua: chuva curta em area, causa dano leve e stun.
            create_particle_effect(
                _player.x,
                _player.y - 100,
                "rain",
                90,
                c_white,
                8,
                360,
                2,
                180
            );

            with (obj_par_inimigos) {
                if (point_distance(x, y, other.x, other.y) <= 120) {
                    if (variable_instance_exists(id, "vida")) {
                        vida -= 2;
                    }

                    if (!variable_instance_exists(id, "stun_timer")) {
                        stun_timer = 0;
                    }

                    stun_timer = max(stun_timer, 35);
                }
            }

            with (obj_par_boss) {
                if (point_distance(x, y, other.x, other.y) <= 120) {
                    if (variable_instance_exists(id, "vida")) {
                        vida -= 1;
                    }
                }
            }

            scr_screen_shake(2, 10);
            _casted = true;
        break;

        case 2:
            gc_quest_toast("Trovao ainda nao foi dominado", 100);
        break;

        case 3:
            // A magia de planta ja esta prevista como cura no design.
            if (_player.vida < _player.max_vida) {
                _player.vida = min(_player.max_vida, _player.vida + 3);

                create_particle_effect(
                    _player.x,
                    _player.y,
                    "spark",
                    50,
                    c_green,
                    20,
                    360,
                    2,
                    20
                );

                _casted = true;
            }
            else {
                gc_quest_toast("Vida ja esta cheia", 75);
            }
        break;

        case 4:
            gc_quest_toast("Shooter ainda nao foi dominado", 100);
        break;
    }

    if (!_casted) return false;

    _player.estamina = max(0, _player.estamina - _cost);
    _player.magia_cooldown = gc_magic_cooldown(_slot);

    return true;
}
